using JSON

function getVarLength(fh)
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

function writeVarLength(fh, n)
  res = UInt8[]
  while n > 127
    push!(res, n & 127 | 0b10000000)
    n /= 128
  end
  push!(res, n)
  write(fh, res)
end

function readString(fh)
  length = getVarLength(fh)
  res = ""

  for i in 1:length
    b = read(fh, UInt8)
    res *= string(Char(b))
  end
  return res
end

function writeString(fh, s)
  s = [UInt8(c) for c in s]
  writeVarLength(fh, length(s))
  write(fh, s)
end

function readRunLengthEncoded(fh)
  byteCount = read(fh, UInt16)
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

function decodeValue(typ, lookup, fh)
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

function encodeRunLength(s)
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

function encodeValue(buffer::IOBuffer, key::String, value::Bool, lookup::Array{String, 1})
  write(buffer, 0x0)
  write(buffer, value)
end


function encodeValue(buffer::IOBuffer, key::String, value::Integer, lookup::Array{String, 1})
  for (i, t) in enumerate(numTypes)
    if typemin(t) <= value <= typemax(t)
      write(buffer, UInt8(i))
      write(buffer, t(value))
     
      break
    end
  end
end

function encodeValue(buffer::IOBuffer, key::String, value::AbstractFloat, lookup::Array{String, 1})
  write(buffer, 0x4)
  write(buffer, Float32(value))
end

function encodeValue(buffer::IOBuffer, key::String, value::String, lookup::Array{String, 1})
  index = findfirst(lookup, value) - 1

  if index < 0
    if key == "innerText"
      value = encodeRunLength(value)

      write(buffer, 0x7)
      write(buffer, UInt16(length(value)))
      write(buffer, value)

    else
      write(buffer, 0x6)
      writeString(buffer, value)
    end

  else
    write(buffer, 0x5)
    write(buffer, Int16(index))
  end
end

function decodeElement(fh, parent, lookup)
  element = Dict{String, Any}()
  name = look(lookup, fh)
  attributeCount = read(fh, UInt8)

  for i in 1:attributeCount
    key = look(lookup, fh)
    typ = read(fh, UInt8)

    value = decodeValue(typ, lookup, fh)
    element[key] = value
  end

  elementCount = read(fh, UInt16)

  if haskey(parent, name)
    if !isa(parent[name], Array)
      parent[name] = Dict{String,Any}[parent[name]]
    end

    push!(parent[name], element)

  else
    parent[name] = element
  end

  for i in 1:elementCount
    decodeElement(fh, element, lookup)
  end
end

function decodeMap(fn::String, checkHeader::Bool=true)
  fh = open(fn, "r")
  if checkHeader
    if readString(fh) != "CELESTE MAP"
      println("Invalid Celeste map file.")
      return false
    end
  end
  package = readString(fh)
  lookupLength = read(fh, Int16)
  lookup = String[]
  for i = 1:lookupLength
    push!(lookup, readString(fh))
  end

  res = Dict{String, Any}()
  decodeElement(fh, res, lookup)
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

function populateEncodeKeyNames!(d, seen::Dict{String, Bool})
  seen[d["__name"]] = true
  children = get(d, "__children", [])

  for (k, v) in d
    if !startswith(k, "__")
      seen[k] = true
    end
    if isa(v, String) && k != "innerText"
      seen[v] = true
    end
  end

  for child in children
    populateEncodeKeyNames!(child, seen)
  end
end

function getAttributeNames(d::Dict{String, Any})
  attr = Dict{String, Any}()

  for (k, v) in d
    if !startswith(k, "_")
      attr[k] = v
    end
  end

  return attr
end

function encodeValue(buffer::IOBuffer, elements::Array{Dict{String, Any}}, lookup::Array{String})
  for element in elements
    encodeValue(buffer, element, lookup)
  end
end

function encodeValue(buffer::IOBuffer, element::Dict{String, Any}, lookup::Array{String})
  attributes = getAttributeNames(element)
  children = get(element, "__children", Dict{String, Any}[])

  write(buffer, UInt16(findfirst(lookup, element["__name"]) - 1))
  write(buffer, UInt8(length(keys(attributes))))

  for (attr, value) in attributes
    if !startswith(attr, "_")
      write(buffer, UInt16(findfirst(lookup, attr) - 1))
      encodeValue(buffer, attr, value, lookup)
    end
  end

  write(buffer, UInt16(length(children)))
  encodeValue(buffer, children, lookup)
end

function encodeMap(map::Dict{String, Any}, outfile::String)
  seen = Dict{String, Bool}()
  populateEncodeKeyNames!(map, seen)
  lookup = collect(keys(seen))
  buffer = IOBuffer()

  writeString(buffer, "CELESTE MAP")
  writeString(buffer, map["_package"])
  write(buffer, Int16(length(lookup)))

  for s in lookup
    writeString(buffer, s)
  end

  encodeValue(buffer, map, lookup)

  open(outfile, "w") do fh
    write(fh, buffer.data)
  end
end