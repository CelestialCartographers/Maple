using JSON

@fieldproxy struct DecodedElement
  name::String
  attributes::Dict{String, Any}
  children::Array{DecodedElement, 1}

  DecodedElement() = new("", Dict{String, Any}(), DecodedElement[])
  DecodedElement(name::String, attributes::Dict{String, Any}, children::Array{DecodedElement, 1}) = new(name, attributes, children)
end attributes

function getVarLength(fh::IOBuffer)
  res = 0
  count = 0
  while true
    byte = read(fh, UInt8)
    res += (byte & 127) << (count * 7)
    count += 1
    if (byte >> 7) == 0
      return res
    end
  end
end

function writeVarLength(fh::IOBuffer, n::Integer)
  res = UInt8[]
  while n > 127
    push!(res, n & 127 | 0b10000000)
    n = floor(Int, n / 128)
  end
  push!(res, n)
  write(fh, res)
end

function readString(fh::IOBuffer)
  length = getVarLength(fh)
  bytes = read(fh, length)
  return String(bytes)
end

function writeString(fh::IOBuffer, s::String)
  bytes = codeunits(s)
  writeVarLength(fh, length(bytes))
  write(fh, bytes)
end

function readRunLengthEncoded(fh::IOBuffer)
  byteCount = read(fh, Int16)
  data = Array{UInt8, 1}(undef, byteCount)
  parts = Array{String, 1}(undef, div(byteCount, 2))
  partIndex = 1
  readbytes!(fh, data, byteCount)
  for i = 1:2:byteCount
    times, char = data[i], data[i + 1]
    parts[partIndex] = string(Char(char)) ^ times
    partIndex += 1
  end
  return join(parts)
end

look(lookup, fh) = lookup[read(fh, UInt16) + 1]

function decodeValue(type::UInt8, lookup::Array{String, 1}, fh::IOBuffer)
  if type == 0
    return read(fh, Bool)
  elseif type == 1
    return read(fh, UInt8)
  elseif type == 2
    return read(fh, Int16)
  elseif type == 3
    return read(fh, Int32)
  elseif type == 4
    return read(fh, Float32)
  elseif type == 5
    return look(lookup, fh)
  elseif type == 6
    return readString(fh)
  elseif type == 7
    return readRunLengthEncoded(fh)
  end
end

function encodeRunLength(s::String)
  # Only allow run length encoding if the string contains only 1 byte characters
  # Celeste does not read it as expected otherwise, this is mainly a tile issue
  if length(s) != ncodeunits(s)
    return nothing
  end

  count::UInt8 = 1
  res = UInt8[]
  current::Char = s[1]

  for (i, c) in enumerate(s[2:end])
    if c != current || count == 255
      push!(res, count)
      push!(res, current)

      count = 1
      current = c
    else
      count += 1
    end
  end

  push!(res, count)
  push!(res, current)

  return res
end

function encodeValue(buffer::IOBuffer, key::String, value::Bool, lookup::Dict{String, Int})
  write(buffer, 0x0)
  write(buffer, value)
end

# Number types are UInt8, Int16, Int32, prefered in that order
function encodeValue(buffer::IOBuffer, key::String, value::Integer, lookup::Dict{String, Int})
    if typemin(UInt8) <= value <= typemax(UInt8)
      write(buffer, UInt8(1))
      write(buffer, UInt8(value))
    elseif typemin(Int16) <= value <= typemax(Int16)
      write(buffer, UInt8(2))
      write(buffer, Int16(value))
    elseif typemin(Int32) <= value <= typemax(Int32)
      write(buffer, UInt8(3))
      write(buffer, Int32(value))
    end
end

function encodeValue(buffer::IOBuffer, key::String, value::AbstractFloat, lookup::Dict{String, Int})
  write(buffer, 0x4)
  write(buffer, Float32(value))
end

function encodeValue(buffer::IOBuffer, key::String, value::String, lookup::Dict{String, Int})
  index = get(lookup, value, 0) - 1

  if index < 0
    encodedValue = encodeRunLength(value)
    encodedLength = encodedValue !== nothing ? length(encodedValue) : typemax(Int32)

    # Run length encoding has a hardcoded max length, make sure we don't exceed the limit
    if encodedLength < ncodeunits(value) && encodedLength <= typemax(Int16)
      write(buffer, 0x7)
      write(buffer, Int16(encodedLength))
      write(buffer, encodedValue)

    else
      write(buffer, 0x6)
      writeString(buffer, value)
    end

  else
    write(buffer, 0x5)
    write(buffer, Int16(index))
  end
end

function decodeElement(fh::IOBuffer, lookup::Array{String, 1})
  name = look(lookup, fh)

  attributeCount = read(fh, UInt8)
  attributes = Dict{String, Any}()

  for i in 1:attributeCount
    key = look(lookup, fh)
    type = read(fh, UInt8)

    value = decodeValue(type, lookup, fh)
    attributes[key] = value
  end

  childCount = read(fh, UInt16)
  children = Array{DecodedElement, 1}(undef, childCount)

  for i in 1:childCount
    children[i] = decodeElement(fh, lookup)
  end

  element = DecodedElement(name, attributes, children)

  return element
end

function decodeMap(fn::String, checkHeader::Bool=true)
  buffer = IOBuffer(open(read, fn))
  if checkHeader
    if readString(buffer) != "CELESTE MAP"
      println("Invalid Celeste map file.")
      close(buffer)

      return false
    end
  end
  package = readString(buffer)
  lookupLength = read(buffer, Int16)
  lookup = String[]
  for i = 1:lookupLength
    push!(lookup, readString(buffer))
  end

  res = decodeElement(buffer, lookup)
  res.attributes["package"] = package

  return res
end

function decodeAllMaps(maps::String, output::String)
  mapBins = [f for f in readdir(maps) if isfile(joinpath(maps, f)) && endswith(f, ".bin")]
  for fn in mapBins
    map = decodeMap(joinpath(maps, fn))
    open(joinpath(output, basename(fn) * ".json"), "w") do fh
      write(fh, JSON.json(map, 4))
    end
  end
end

function populateEncodeKeyNames!(d::Dict{String, Any}, seen::Set{String})
  name = d["__name"]
  push!(seen, name)

  for (k, v) in d
    if !startswith(k, "__")
      push!(seen, k)
    end

    if isa(v, String) && k != "innerText"
      push!(seen, v)
    end
  end

  children = get(d, "__children", nothing)

  if children !== nothing
    for child in children
      populateEncodeKeyNames!(child, seen)
    end
  end
end

function getAttributeNames(d::Dict{String, Any})
  attr = Dict{String, Any}()

  for (k, v) in d
    # Attributes starting with _ are magical, and contains data that shouldn't be written directly
    # Attributes with value nothing should not be written either, and is the lack of attribute instead
    if !startswith(k, "_") && v !== nothing
      attr[k] = v
    end
  end

  return attr
end

function encodeValue(buffer::IOBuffer, elements::Array{Dict{String, Any}}, lookup::Dict{String, Int})
  for element in elements
    encodeValue(buffer, element, lookup)
  end
end

function encodeValue(buffer::IOBuffer, element::Dict{String, Any}, lookup::Dict{String, Int})
  attributes = getAttributeNames(element)
  children = get(Array{Dict{String, Any}, 1}, element, "__children")

  write(buffer, UInt16(get(lookup, element["__name"], 0) - 1))
  write(buffer, UInt8(length(keys(attributes))))

  for (attr, value) in attributes
    write(buffer, UInt16(get(lookup, attr, 0) - 1))
    encodeValue(buffer, attr, value, lookup)
  end

  write(buffer, UInt16(length(children)))
  encodeValue(buffer, children, lookup)
end

function encodeMap(map::Dict{String, Any}, outfile::String)
  seen = Set{String}()
  populateEncodeKeyNames!(map, seen)

  lookup = collect(seen)
  lookupDict = Dict{String, Int}(s => i for (i, s) in enumerate(lookup))
  buffer = IOBuffer()

  writeString(buffer, "CELESTE MAP")
  writeString(buffer, map["_package"])
  write(buffer, Int16(length(lookup)))

  for s in lookup
    writeString(buffer, s)
  end

  encodeValue(buffer, map, lookupDict)

  open(outfile, "w") do fh
    write(fh, buffer.data)
  end
end

function attributes(element::DecodedElement)
  return element.attributes
end

function children(element::DecodedElement)
  return element.children
end

function children(element::Nothing)
  return DecodedElement[]
end

function findChildWithName(element::DecodedElement, name::String)
  for child in element.children
    if child.name == name
      return child
    end
  end
end

function findChildWithName(default::Union{Function, Type}, element::DecodedElement, name::String)
  res = findChildWithName(element, name)

  return res === nothing ? default() : res
end