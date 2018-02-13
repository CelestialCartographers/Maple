@with_kw mutable struct Trigger
    __name::String = ""
    id::Integer = 0

    x::Integer = 0
    y::Integer = 0

    originX::Integer = 0
    originY::Integer = 0

    width::Integer = 16
    height::Integer = 16

    onlyOnce::Bool = true
    mode::String = "" # OnLevelStart

    dialog_id = "" # Textboxes
end

MiniTextBox(x::Integer, y::Integer, width::Integer, height::Integer, dialog_id::String, mode::String, onlyOnce::Bool=true) = Trigger(__name="minitextboxTrigger", x=x, y=y, width=width, height=height, dialog_id=dialog_id, mode=mode, onlyOnce=onlyOnce)

triggerIdSerial = 0
blacklistedTriggerAttrs = String[]
noTriggerDedup = String["x", "y"]
baseTrigger = Trigger()

function Base.Dict(t::Trigger)
    res = Dict{String, Any}()

    for f in fieldnames(t)
        fs = string(f)
        value = getfield(t, f)

        if !(fs in blacklistedTriggerAttrs) && (value != getfield(baseTrigger, f) || fs in noTriggerDedup)
            res[fs] = value
        end
    end

    res["id"] = triggerIdSerial
    global triggerIdSerial += 1

    return res
end