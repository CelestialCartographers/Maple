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

AltMusicTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; track::String="", resetOnLeave::Bool=true) = Trigger("altMusicTrigger", x=x, y=y, width=width, height=height, track=track, resetOnLeave=resetOnLeave)
AmbientParamTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; parameter::String="", from::Number=0.0, to::Number=0.0, direction::String="NoEffect") = Trigger("ambienceParamTrigger", x=x, y=y, width=width, height=height, parameter=parameter, from=from, to=to, direction=direction)
BloomFadeTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; bloomAddFrom::Number=0.0, bloomAddTo::Number=0.0, positionMode::String="NoEffect") = Trigger("bloomFadeTrigger", x=x, y=y, width=width, height=height, bloomAddFrom=bloomAddFrom, bloomAddTo=bloomAddTo, positionMode=positionMode)
CameraAdvanceTargetTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; lerpStrengthX::Number=0.0, lerpStrengthY::Number=0.0, positionModeX::String="NoEffect", positionModeY::String="NoEffect", xOnly::Bool=false, yOnly::Bool=false, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer} = Trigger("cameraAdvanceTargetTrigger", x=x, width=width, height=height, lerpStrengthX=lerpStrengthX, lerpStrengthY=lerpStrengthY, positionModeX=positionModeX, positionModeY=positionModeY, xOnly=xOnly, yOnly=yOnly, nodes=nodes)
CameraOffsetTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; cameraX::Number=0.0, cameraY::Number=0.0) = Trigger("cameraOffsetTrigger", x=x, y=y, width=width, height=height, cameraX=cameraX, cameraY=cameraY)
CameraTargetTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; lerpStrength::Number=0.0, positionMode::String="NoEffect", xOnly::Bool=false, yOnly::Bool=false, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer} = Trigger("cameraTargetTrigger", x=x, y=y, width=width, height=height, positionMode=positionMode, xOnly=xOnly, yOnly=yOnly, nodes=nodes)
ChangeRespawnTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer} = Trigger("changeRespawnTrigger", x=x, y=y, width=width, height=height, nodes=nodes)
CheckpointBlockerTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight) = Trigger("checkpointBlockerTrigger", x=x, y=y, width=width, height=height)
CreditsTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; event::String="") = Trigger("creditsTrigger", x=x, y=y, width=width, height=height, event=event)
EventTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; event::String="") = Trigger("eventTrigger", x=x, y=y, width=width, height=height, event=event)
GoldenBerryCollectionTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight) = Trigger("goldenBerryCollectTrigger", x=x, y=y, width=width, height=height)
#InteractTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; TODO - Needs research
LightFadeTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; lightAddFrom::Number=0.0, lightAddTo::Number=0.0, positionMode::String="NoEffect") = Trigger("lightFadeTrigger", x=x, y=y, width=width, height=height, lightAddFrom=lightAddFrom, lightAddTo=lightAddTo, positionMode=positionMode)
LookoutBlocker(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight) = Trigger("lookoutBlocker", x=x, y=y, width=width, height=height)
MiniTextBoxTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; dialog_id::String="", mode::String="OnPlayerEnter", textbox::String="default", only_once::Bool=true, death_count::Integer=-1) = Trigger("minitextboxTrigger", x=x, y=y, width=width, height=height, dialog_id=dialog_id, mode=mode, only_once=only_once, death_count=death_count, textbox=textbox)
MusicFadeTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; direction::String="leftToRight", fadeA::Number=1.0, fadeB::Number=1.0, parameter::String="") = Trigger("musicFadeTrigger", x=x, y=y, width=width, height=height, direction=direction, fadeA=fadeA, fadeB=fadeB, parameter=parameter)
MusicTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; track::String="", resetOnLeave::Bool=true) = Trigger("musicTrigger", x=x, y=y, width=width, height=height, track=track, resetOnLeave=resetOnLeave)
NoRefillTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, state::Bool=true) = Trigger("noRefillTrigger", x=x, y=y, width=width, height=height, state=state)
OshiroTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, state::Bool=true) = Trigger("oshiroTrigger", x=x, y=y, width=width, height=height, state=state)
RespawnTargetTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer} = Trigger("respawnTargetTrigger", x=x, y=y, width=width, height=height, nodes=nodes)
StopBoostTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight) = Trigger("stopBoostTrigger", x=x, y=y, width=width, height=height)
WindAttackTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight) = Trigger("windAttackTrigger", x=x, y=y, width=width, height=height)
WindTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, pattern::String="None") = Trigger("windTrigger", x=x, y=y, width=width, height=height, pattern=pattern)

EverestFlagTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight) = Trigger("everest/flagTrigger", x=x, y=y, width=width, height=height)

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