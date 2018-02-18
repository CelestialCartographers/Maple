triggerIdSerial = 0

function nextTriggerId()
    return global triggerIdSerial += 1
end

mutable struct Trigger
    name::String
    id::Integer

    data::Dict{String, Any}
end

Trigger(name::String, data::Dict{String, Any}) = Trigger(name, nextTriggerId(), data)

MiniTextBox(x::Integer, y::Integer, width::Integer, height::Integer, dialog_id::String, mode::String, onlyOnce::Bool=true) = Trigger("minitextboxTrigger", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "dialog_id"=>dialog_id, "mode"=>mode, "onlyOnce"=>onlyOnce))

blacklistedTriggerAttrs = String["nodes"]

function Base.Dict(t::Trigger)
    res = Dict{String, Any}()

    res["__name"] = t.name
    res["id"] = t.id
    
    for (key, value) in t.data
        if !(key in blacklistedTriggerAttrs)
            res[key] = value
        end
    end

    if haskey(t.data, "nodes")
        if length(t.data["nodes"]) > 0
            res["__children"] = Dict{String, Any}[]

            for node in t.data["nodes"]
                push!(res["__children"], Dict{String, Any}(
                    "__name" => "node",
                    "x" => node[1],
                    "y" => node[2]
                ))
            end
        end
    end

    return res
end