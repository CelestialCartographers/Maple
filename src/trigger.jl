triggerIdSerial = 0

function nextTriggerId()
    return global triggerIdSerial += 1
end

mutable struct Trigger
    name::String
    id::Integer

    data::Dict{String, Any}
end

const defaultTriggerWidth = 16
const defaultTriggerHeight = 16

# Don't care about the ID
Base.isequal(lhs::Trigger, rhs::Trigger) = lhs.name == rhs.name && lhs.data == rhs.data

Trigger(name::String, data::Dict{String, Any}) = Trigger(name, nextTriggerId(), data)
Trigger(name::String; kwargs...) = Trigger(name, Dict{String, Any}(String(k) => v for (k, v) in kwargs))

MiniTextBox(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, dialog_id::String="", mode::String="OnLevelStart", onlyOnce::Bool=true) = Trigger("minitextboxTrigger", x=x, y=y, width=width, height=height, dialog_id=dialog_id, mode=mode, onlyOnce=onlyOnce)
ChangeRespawnTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight) = Trigger("changeRespawnTrigger", x=x, y=y, width=width, height=height)
NoRefillTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, state::Bool=true) = Trigger("noRefillTrigger", x=x, y=y, width=width, height=height, state=state)
GoldenBerryCollectionTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight) = Trigger("goldenBerryCollectTrigger", x=x, y=y, width=width, height=height)
WindTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, pattern::String="None") = Trigger("windTrigger", x=x, y=y, width=width, height=height, pattern=pattern)
WindAttackTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight) = Trigger("windAttackTrigger", x=x, y=y, width=width, height=height)
EventTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, event::String="end_city") = Trigger("eventTrigger", x=x, y=y, width=width, height=height, event=event)

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