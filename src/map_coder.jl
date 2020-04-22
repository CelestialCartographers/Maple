using JSON

function getVarLength(fh::IOStream)
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

function readString(fh::IOStream)
  length = getVarLength(fh)
  res = ""

  for i in 1:length
    b = read(fh, UInt8)
    res *= string(Char(b))
  end
  return res
end

function writeString(fh::IOBuffer, s::String)
  s = [UInt8(c) for c in s]
  writeVarLength(fh, length(s))
  write(fh, s)
end

function readRunLengthEncoded(fh::IOStream)
  byteCount = read(fh, Int16)
  data = UInt8[]
  res = ""
  for i = 1:byteCount
    append!(data, read(fh, UInt8))
  end
  for i = 1:2:length(data)
    times, char = data[i], data[i + 1]
    res *= string(Char(char)) ^ times
  end
  return res
end

look(lookup, fh) = lookup[read(fh, UInt16) + 1]

decodeTypes = Dict{Integer, Type}(
  0 => Bool,
  1 => UInt8,
  2 => Int16,
  3 => Int32,
  4 => Float32
)

function decodeValue(typ::Any, lookup::Array{String, 1}, fh::IOStream)
  if 0 <= typ <= 4
    return read(fh, decodeTypes[typ])
  elseif typ == 5
    return look(lookup, fh)
  elseif typ == 6
    return readString(fh)
  elseif typ == 7
    return readRunLengthEncoded(fh)
  end
end

function encodeRunLength(s::String)
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

numTypes = [
  UInt8,
  Int16,
  Int32
]

function encodeValue(buffer::IOBuffer, key::String, value::Bool, lookup::Dict{String, Int})
  write(buffer, 0x0)
  write(buffer, value)
end

function encodeValue(buffer::IOBuffer, key::String, value::Integer, lookup::Dict{String, Int})
  for (i, t) in enumerate(numTypes)
    if typemin(t) <= value <= typemax(t)
      write(buffer, UInt8(i))
      write(buffer, t(value))
     
      break
    end
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
    encodedLength = length(encodedValue)

    if encodedLength < length(value) && encodedLength <= typemax(Int16)
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

function decodeElement(fh::IOStream, lookup::Array{String, 1})
  name = look(lookup, fh)
  attributeCount = read(fh, UInt8)

  element = Dict{String, Any}("__name" => name)

  for i in 1:attributeCount
    key = look(lookup, fh)
    typ = read(fh, UInt8)

    value = decodeValue(typ, lookup, fh)
    element[key] = value
  end

  elementCount = read(fh, UInt16)

  if elementCount > 0
    element["__children"] = Any[]
    for i in 1:elementCount
      push!(element["__children"], decodeElement(fh, lookup))
    end
  end

  return element
end

function decodeMap(fn::String, checkHeader::Bool=true)
  fh = open(fn, "r")
  if checkHeader
    if readString(fh) != "CELESTE MAP"
      println("Invalid Celeste map file.")
      close(fh)

      return false
    end
  end
  package = readString(fh)
  lookupLength = read(fh, Int16)
  lookup = String[]
  for i = 1:lookupLength
    push!(lookup, readString(fh))
  end

  res = decodeElement(fh, lookup)
  res["_package"] = package
  close(fh)

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

function populateEncodeKeyNames!(d::Dict{String, Any}, seen::Dict{String, Integer})
  name = d["__name"]
  seen[name] = get(seen, name, 0) + 1

  children = get(Array{Dict{String, Any}, 1}, d, "__children")

  for (k, v) in d
    if !startswith(k, "__")
      seen[k] = get(seen, k, 0) + 1
    end

    if isa(v, String) && k != "innerText"
      seen[v] = get(seen, v, 0) + 1
    end
  end

  for child in children
    populateEncodeKeyNames!(child, seen)
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
  seen = Dict{String, Integer}()
  populateEncodeKeyNames!(map, seen)

  lookup = String[k for (k, v) in seen]
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

function attributes(element::Dict{String, Any})
  return Dict{String, Any}((k, v) for (k, v) in element if !startswith(k, "__"))
end

function children(element::Dict{String, Any})
  return get(Array{Any, 1}, element, "__children")
end

function children(element::Nothing)
  return Any[]
end

function findChildWithName(element::Dict{String, Any}, name::String)
  for child in get(Array{Any, 1}, element, "__children")
    if child["__name"] == name
      return child
    end
  end
end

function findChildWithName(default::Union{Function, Type}, element::Dict{String, Any}, name::String)
  res = findChildWithName(element, name)

  return res === nothing ? default() : res
end