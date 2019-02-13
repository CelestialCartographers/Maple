@fieldproxy mutable struct Trigger{T}
    name::String
    data::Dict{String, Any}

    id::Integer

    Trigger{T}(name::String, data::Dict{String, Any}, id::Integer=nextEntityId()) where T = new{T}(name, data, id)
    Trigger{T}(name::String, id::Integer=nextEntityId(); kwargs...) where T = new{T}(name, Dict{String, Any}(String(k) => v for (k, v) in kwargs), id)

    Trigger(name::String, data::Dict{String, Any}, id::Integer=nextEntityId()) = new{Symbol(name)}(name, data, id)
    Trigger(name::String, id::Integer=nextEntityId(); kwargs...) = new{Symbol(name)}(name, Dict{String, Any}(String(k) => v for (k, v) in kwargs), id)
end

const defaultTriggerWidth = 16
const defaultTriggerHeight = 16

# Don't care about the ID
Base.:(==)(lhs::Trigger{T}, rhs::Trigger{T}) where T = lhs.data == rhs.data


@mapdef Trigger "altMusicTrigger" AltMusicTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; track::String="", resetOnLeave::Bool=true)
@mapdef Trigger "ambienceParamTrigger" AmbienceParamTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; parameter::String="", from::Number=0.0, to::Number=0.0, direction::String="NoEffect")
@mapdef Trigger "bloomFadeTrigger" BloomFadeTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; bloomAddFrom::Number=0.0, bloomAddTo::Number=0.0, positionMode::String="NoEffect")
@mapdef Trigger "cameraOffsetTrigger" CameraOffsetTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; cameraX::Number=0.0, cameraY::Number=0.0)
@mapdef Trigger "checkpointBlockerTrigger" CheckpointBlockerTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight)
@mapdef Trigger "creditsTrigger" CreditsTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; event::String="")
@mapdef Trigger "eventTrigger" EventTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; event::String="")
@mapdef Trigger "goldenBerryCollectTrigger" GoldenBerryCollectionTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight)
@mapdef Trigger "lightFadeTrigger" LightFadeTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; lightAddFrom::Number=0.0, lightAddTo::Number=0.0, positionMode::String="NoEffect")
@mapdef Trigger "lookoutBlocker" LookoutBlocker(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight)
@mapdef Trigger "minitextboxTrigger" MiniTextBoxTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; dialog_id::String="", mode::String="OnPlayerEnter", only_once::Bool=true, death_count::Integer=-1)
@mapdef Trigger "musicFadeTrigger" MusicFadeTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; direction::String="leftToRight", fadeA::Number=0.0, fadeB::Number=1.0, parameter::String="")
@mapdef Trigger "musicTrigger" MusicTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; track::String="", resetOnLeave::Bool=true)
@mapdef Trigger "noRefillTrigger" NoRefillTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, state::Bool=true)
@mapdef Trigger "oshiroTrigger" OshiroTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, state::Bool=true)
@mapdef Trigger "stopBoostTrigger" StopBoostTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight)
@mapdef Trigger "windAttackTrigger" WindAttackTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight)
@mapdef Trigger "windTrigger" WindTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, pattern::String="None")

@mapdef Trigger "cameraTargetTrigger" CameraTargetTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; lerpStrength::Number=0.0, positionMode::String="NoEffect", xOnly::Bool=false, yOnly::Bool=false, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
@mapdef Trigger "cameraAdvanceTargetTrigger" CameraAdvanceTargetTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; lerpStrengthX::Number=0.0, lerpStrengthY::Number=0.0, positionModeX::String="NoEffect", positionModeY::String="NoEffect", xOnly::Bool=false, yOnly::Bool=false, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
@mapdef Trigger "changeRespawnTrigger" ChangeRespawnTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
@mapdef Trigger "respawnTargetTrigger" RespawnTargetTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight; nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])

@mapdef Trigger "everest/flagTrigger" EverestFlagTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, flag::String="", state::Bool=false, mode::String="OnPlayerEnter", only_once::Bool=false, death_count::Integer=-1)
@mapdef Trigger "everest/dialogTrigger" EverestDialogTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, endLevel::Bool=false)
@mapdef Trigger "everest/crystalShatterTrigger" EverestCrystalShatterTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, mode::String="All")
@mapdef Trigger "everest/completeAreaTrigger" EverestCompleteAreaTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight)
@mapdef Trigger "everest/changeInventoryTrigger" EverestChangeInventoryTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, inventory::String="Default")
@mapdef Trigger "everest/lavaBlockerTrigger" EverestLavaBlockerTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, canReenter::Bool=false)
@mapdef Trigger "everest/coreModeTrigger" EverestCoreModeTrigger(x::Integer, y::Integer, width::Integer=defaultTriggerWidth, height::Integer=defaultTriggerHeight, mode::String="None")

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