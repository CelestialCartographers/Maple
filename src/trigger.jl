triggerIdSerial = 0

function nextTriggerId()
    return global triggerIdSerial += 1
end

@with_kw mutable struct Trigger
    name::String = ""
    id::Integer = nextTriggerId()

    data::Dict{String, Any} = Dict{String, Any}()
end

function Trigger(name::String, data)
    return Trigger(name=name, data=data)
end

MiniTextBox(x::Integer, y::Integer, width::Integer, height::Integer, dialog_id::String, mode::String, onlyOnce::Bool=true) = Trigger("minitextboxTrigger", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "dialog_id"=>dialog_id, "mode"=>mode, "onlyOnce"=>onlyOnce))

blacklistedTriggerAttrs = String[]

function Base.Dict(t::Trigger)
    res = Dict{String, Any}()

    res["__name"] = t.name
    res["id"] = t.id
    
    for (key, value) in t.data
        if !(key in blacklistedTriggerAttrs)
            res[key] = value
        end
    end

    return res
end