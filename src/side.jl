include("map.jl")

@valueequals mutable struct Side
    map::Map
    data::Dict{String, Any}

    Side(map::Map, data::Dict{String, Any}=Dict{String, Any}()) = new(map, data)
end

const decoderBlacklist = String[
    "Filler", "Style", "levels"
]

function Base.Dict(s::Side)
    data = Dict(s.map)
    encodeMetadata!(data, s.data)

    return data
end

function loadDataAsDict!(target::Dict{String, Any}, data::DecodedElement)
    name = data.name
    target[name] = Dict{String, Any}()

    for (attr, value) in attributes(data)
        target[name][attr] = value
    end

    for child in children(data)
        loadDataAsDict!(target[name], child)
    end
end

function dictAsEncodedData(name::String, data::Dict{String, Any})
    res = Dict{String, Any}(
        "__name" => name,
        "__children" => Dict{String, Any}[]
    )

    for (k, v) in data
        if isa(v, Dict)
            push!(res["__children"], dictAsEncodedData(k, v))

        else
            res[k] = v
        end
    end

    if isempty(res["__children"])
        delete!(res, "__children")
    end

    return res
end

function loadMetadata(data::DecodedElement)
    res = Dict{String, Any}()

    for child in children(data)
        if !(child.name in decoderBlacklist)
            loadDataAsDict!(res, child)
        end
    end

    return res
end

loadSide(fn::String) = loadSide(decodeMap(fn))
function loadSide(data::DecodedElement)
    return Side(loadMap(data), loadMetadata(data))
end

function encodeMetadata!(target::Dict{String, Any}, data::Dict{String, Any})
    for (k, v) in data
        push!(target["__children"], dictAsEncodedData(k, v))
    end
end

function encodeSide(side::Side, outfile::String)
    return encodeMap(Dict(side), outfile)
end

function getSideName(side::Side)
    if haskey(side.data, "meta") && haskey(side.data["meta"], "Name") && !isempty(side.data["meta"]["Name"])
        return side.data["meta"]["Name"]

    else
        return side.map.package
    end
end