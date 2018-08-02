include("map.jl")

mutable struct Side
    map::Map
    data::Dict{String, Any}

    Side(map::Map, data::Dict{String, Any}=Dict{String, Any}()) = new(map, data)
end

function loadMetadata(data::Dict{String, Any})
    res = Dict{String, Any}()

    for (attr, value) in data["Map"]
        if attr == "levels" || attr == "Style" || attr == "Filler"
            continue
        end

        res[attr] = value
    end

    return res
end

loadSide(fn::String) = loadSide(decodeMap(fn))
function loadSide(data::Dict{String, Any})
    return Side(loadMap(data), loadMetadata(data))
end

function encodeMetadata!(data::Dict{String, Any}, res::Dict{String, Any}=Dict{String, Any}())
    for (attr, value) in data
        if isa(value, Dict) || isa(value, Array)
            values = packIfDict(value)

            if !haskey(res, "__children")
                res["__children"] = Dict{String, Any}[]
            end

            for v in values
                push!(res["__children"], Dict{String, Any}(
                    "__name" => attr
                ))

                encodeMetadata!(v, res["__children"][end])
            end

        else
            res[attr] = value
        end
    end
end

function encodeSide(side::Side, outfile::String)
    data = Dict(side.map)

    encodeMetadata!(side.data, data)

    return encodeMap(data, outfile)
end

function getSideName(side::Side)
    if haskey(side.data, "meta") && haskey(side.data["meta"], "Name") && !isempty(side.data["meta"]["Name"])
        return side.data["meta"]["Name"]

    else
        return side.map.package
    end
end