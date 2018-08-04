entityIdSerial = 0

const defaultBlockWidth = 16
const defaultBlockHeight = 16

const defaultSpikeWidth = 8
const defaultSpikeHeight = 8

function nextEntityId()
    return global entityIdSerial += 1
end

mutable struct Entity
    name::String
    id::Integer

    data::Dict{String, Any}
end

# Don't care about the ID
Base.isequal(lhs::Entity, rhs::Entity) = lhs.name == rhs.name && lhs.data == rhs.data

Entity(name::String, data::Dict{String, Any}) = Entity(name, nextEntityId(), data)
Entity(name::String; kwargs...) = Entity(name, Dict{String, Any}(String(k) => v for (k, v) in kwargs))

Player(x::Integer, y::Integer) = Entity("player", x=x, y=y, width=8)
DarkChaser(x::Integer, y::Integer) = Entity("darkChaser", x=x, y=y)

# Added by Everest to make Dark Chasers useable by custom maps
DarkChaserEnd(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Main.Maple.Entity("darkChaserEnd", x=x, y=y, width=width, height=height)
DarkChaserBarrier = DarkChaserEnd

function Strawberry(x::Integer, y::Integer, winged::Bool=false, checkpointID::Integer=-1, order::Integer=-1, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity("strawberry", x=x, y=y, winged=winged, nodes=nodes, checkpointID=checkpointID, order=order)
end

function GoldenStrawberry(x::Integer, y::Integer, winged::Bool=false, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity("goldenBerry", x=x, y=y, winged=winged, nodes=nodes)
end

function BadelineBoost(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], lockCamera::Bool=true) where {T <: Integer}
    return Entity("badelineBoost", x=x, y=y, lockCamera=lockCamera, nodes=nodes)
end

function BadelineBoss(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], patternIndex::Integer=1, startHit::Bool=false, cameraPastY::Number=120.0, lockCamera::Bool=true) where {T <: Integer}
    return Entity("finalBoss", x=x, y=y, startHit=startHit, nodes=nodes, patternIndex=patternIndex, cameraPastY=cameraPastY, lockCamera=lockCamera)
end

function FireBall(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], amount::Integer=1, offset::Number=0, speed::Number=1) where {T <: Integer}
    return Entity("fireBall", x=x, y=y, amount=amount, offset=offset, speed=speed, nodes=nodes)
end

function Tentacles(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], fear_distance::String="close", slide_until::Integer=0) where {T <: Integer}
    return Entity("tentacles", x=x, y=y, slide_until=slide_until, nodes=nodes, fear_distance=fear_distance)
end

function Cobweb(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity("cobweb", x=x, y=y, nodes=nodes)
end

function Seeker(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity("seeker", x=x, y=y, nodes=nodes)
end

Cassette(x1::Integer, y1::Integer, x2::Integer=x1, y2::Integer=y1) = Entity("cassette", x=x1, y=y1, nodes=[(0, 0), (x2, y2)])

Towerviewer(x::Integer, y::Integer) = Entity("towerviewer", x=x, y=y)
Lookout = Towerviewer

FloatingDebris(x::Integer, y::Integer) = Entity("floatingDebris", x=x, y=y)
ForegroundDebris(x::Integer, y::Integer) = Entity("foregroundDebris", x=x, y=y)

DreamMirror(x::Integer, y::Integer) = Entity("dreammirror", x=x, y=y)

Refill(x::Integer, y::Integer) = Entity("refill", x=x, y=y)
Feather(x::Integer, y::Integer, shielded::Bool=false, singleUse::Bool=false) = Entity("infiniteStar", x=x, y=y, shielded=shielded, singleUse=singleUse)

# Everest needs null values here for automatic fills
# Inventory and Dreaming has to be nullable, -1 for checkpointID is considered null
ChapterCheckpoint(x::Integer, y::Integer, inventory::Union{String, Void}=nothing, dreaming::Union{Bool, Void}=nothing, checkpointID::Integer=-1; allowOrigin::Bool=false) = Entity("checkpoint", x=x, y=y, allowOrigin=allowOrigin, inventory=inventory, dreaming=dreaming, checkpointID=checkpointID)

Checkpoint(x::Integer, y::Integer, number::Integer=0) = Entity("summitcheckpoint", x=x, y=y, number=number)

SpikesUp(x::Integer, y::Integer, width::Integer=defaultSpikeWidth, variant::String="default") = Entity("spikesUp", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "type"=>variant))
SpikesDown(x::Integer, y::Integer, width::Integer=defaultSpikeWidth, variant::String="default") = Entity("spikesDown", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "type"=>variant))
SpikesLeft(x::Integer, y::Integer, height::Integer=defaultSpikeHeight, variant::String="default") = Entity("spikesLeft", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height, "type"=>variant))
SpikesRight(x::Integer, y::Integer, height::Integer=defaultSpikeHeight, variant::String="default") = Entity("spikesRight", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height, "type"=>variant))

TriggerSpikesUp(x::Integer, y::Integer, width::Integer=defaultSpikeWidth) = Entity("triggerSpikesUp", x=x, y=y, width=width)
TriggerSpikesDown(x::Integer, y::Integer, width::Integer=defaultSpikeWidth) = Entity("triggerSpikesDown", x=x, y=y, width=width)
TriggerSpikesLeft(x::Integer, y::Integer, height::Integer=defaultSpikeHeight) = Entity("triggerSpikesLeft", x=x, y=y, height=height)
TriggerSpikesRight(x::Integer, y::Integer, height::Integer=defaultSpikeHeight) = Entity("triggerSpikesRight", x=x, y=y, height=height)

# Added by Everest
TriggerSpikesOriginalUp(x::Integer, y::Integer, width::Integer=defaultSpikeWidth) = Main.Maple.Entity("triggerSpikesOriginalUp", x=x, y=y, width=width)
TriggerSpikesOriginalDown(x::Integer, y::Integer, width::Integer=defaultSpikeWidth) = Main.Maple.Entity("triggerSpikesOriginalDown", x=x, y=y, width=width)
TriggerSpikesOriginalLeft(x::Integer, y::Integer, height::Integer=defaultSpikeHeight) = Main.Maple.Entity("triggerSpikesOriginalLeft", x=x, y=y, height=height)
TriggerSpikesOriginalRight(x::Integer, y::Integer, height::Integer=defaultSpikeHeight) = Main.Maple.Entity("triggerSpikesOriginalRight", x=x, y=y, height=height)

RotateSpinner(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, clockwise::Bool=false) = Entity("rotateSpinner", x=x1, y=y1, nodes=[(x2, y2)], clockwise=clockwise)
Spinner(x::Integer, y::Integer, attachToSolid::Bool=false) = Entity("spinner", x=x, y=y, attachToSolid=attachToSolid)
TrackSpinner(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, speed::String="Normal", startCenter::Bool=false) = Entity("trackSpinner", x=x1, y=y1, nodes=[(x2, y2)], speed=speed, startCenter=startCenter)

JumpThru(x::Integer, y::Integer, width::Integer=8, texture::String="wood") = Entity("jumpThru", x=x, y=y, width=width, texture=texture)
Platform = JumpThru

Booster(x::Integer, y::Integer, red::Bool=false) = Entity("booster", x=x, y=y, red=red)
GreenBooster(x::Integer, y::Integer) = Booster(x, y, false) # Helper
RedBooster(x::Integer, y::Integer) = Booster(x, y, true) # Helper
WallBooster(x::Integer, y::Integer, height::Integer=8, left::Bool=false) = Entity("wallBooster", x=x, y=y, height=height, left=left)

Lightbeam(x::Integer, y::Integer, width::Integer, height::Integer, rotation::Integer=0) = Entity("lightbeam", x=x, y=y, width=width, height=height, rotation=rotation)

Torch(x::Integer, y::Integer, startLit::Bool=false) = Entity("torch", x=x, y=y, startLit=startLit)

Wire(x1::Integer, y1::Integer, x2::Integer=x1 + 8, y2::Integer=y1, above::Bool=false) = Entity("wire", x=x1, y=y1, nodes=[(x2, y2)], above=above)
ClothesLine(x1::Integer, y1::Integer, x2::Integer, y2::Integer) = Entity("clothesline", x=x1, y=y1, nodes=[(x2, y2)])

SwapBlock(x1::Integer, y1::Integer, x2::Integer=x1+16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("swapBlock", x=x1, y=y1, width=width, height=height, nodes=[(x2, y2)])

SwitchGate(x1::Integer, y1::Integer, x2::Integer=x1+16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, persistent::Bool=false, sprite::String="block") = Entity("switchGate", x=x1, y=y1, width=width, height=height, nodes=[(x2, y2)], persistent=persistent, sprite=sprite)
TouchSwitch(x::Integer, y::Integer) = Entity("touchSwitch", x=x, y=y)

SinkingPlatform(x::Integer, y::Integer, width::Integer=defaultBlockWidth) = Entity("sinkingPlatform", x=x, y=y, width=width)
MovingPlatform(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, width::Integer=defaultBlockWidth) = Entity("movingPlatform", x=x1, y=y1, nodes=[(x2, y2)], width=width)

ZipMover(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockWidth) = Entity("zipMover", x=x1, y=y1, nodes=[(x2, y2)], width=width, height=height)

CoreFlag(x::Integer, y::Integer, onlyIce::Bool=false, onlyFire::Bool=false, persistent::Bool=false) = Entity("coreModeToggle", x=x, y=y, onlyIce=onlyIce, onlyFire=onlyFire, persistent=persistent)

Slider(x::Integer, y::Integer, clockwise::Bool=true, surface::String="Floor") = Entity("slider", x=x, y=y, clockwise=clockwise, surface=surface)

CrystalHeart(x::Integer, y::Integer) = Entity("blackGem", x=x, y=y)
HeartDoor(x::Integer, y::Integer, width::Integer, height::Integer, requires::Integer) = Entity("heartGemDoor", x=x, y=y, width=width, height=height, requires=requires)

CrumbleBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth) = Entity("crumbleBlock", x=x, y=y, width=width)
FakeWall(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3") = Entity("fakeWall", x=x, y=y, width=width, height=height, tiletype=tiletype)
ExitBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3") = Entity("exitBlock", x=x, y=y, width=width, height=height, tileType=tiletype)
ConditionBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3", condition::String="Key", conditionID::String="1:1") = Entity("conditionBlock", x=x, y=y, width=width, height=height, tileType=tiletype, condition=condition, conditionID=conditionID)
CoverupWall(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3") = Entity("coverupWall", x=x, y=y, width=width, height=height, tiletype=tiletype)
DashBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3", blendin::Bool=true, canDash::Bool=true, permanent::Bool=true) = Entity("dashBlock", x=x, y=y, width=width, height=height, tiletype=tiletype, blendin=blendin, canDash=canDash, permanent=permanent)
FallingBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3", climbFall::Bool=true, behind::Bool=false, finalBoss::Bool=false) = Entity("fallingBlock", x=x, y=y, width=width, height=height, climbFall=climbFall, tiletype=tiletype, finalBoss=finalBoss, behind=behind)

# Is actually not resizable, but still has a width for collision purposes
RidgeGate(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, strawberries::String="1:1,2:2") = Entity("ridgeGate", x=x1, y=y1, nodes=[(x2, y2)], width=32, height=32, strawberries=strawberries)

CassetteBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, index::Integer=0) = Entity("cassetteBlock", x=x, y=y, width=width, height=height, index=index)
NegaBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("negaBlock", x=x, y=y, width=width, height=height)
MoveBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, direction::String="Up", canSteer::Bool=false, fast::Bool=false) = Entity("moveBlock", x=x, y=y, width=width, height=height, direction=direction, canSteer=canSteer, fast=fast)
CrushBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, axes::String="both") = Entity("crushBlock", x=x, y=y, width=width, height=height, axes=axes)
KevinBlock = CrushBlock

IceBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("iceBlock", x=x, y=y, width=width, height=height)
FireBarrier(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("fireBarrier", x=x, y=y, width=width, height=height)

DreamBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("dreamBlock", x=x, y=y, width=width, height=height)
MovingDreamBlock(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, fastMoving::Bool=false) = Entity("dreamBlock", x=x1, y=y1, nodes=[(x2, y2)], width=width, height=height, fastMoving=fastMoving)
SpaceJam = DreamBlock
MovingSpaceJam = MovingDreamBlock

StarJumpController(x::Integer, y::Integer) = Entity("starClimbController", x=x, y=y)
StarJumpBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, sinks::Bool=true) = Entity("starJumpBlock", x=x, y=y, width=width, height=height, sinks=sinks)

BlockField(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("blockField", x=x, y=y, width=width, height=height)
StrawberryBlockField = BlockField

BounceBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("bounceBlock", x=x, y=y, width=width, height=height)

WhiteBlock(x::Integer, y::Integer) = Entity("whiteblock", x=x, y=y)

Barrier(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("invisibleBarrier", x=x, y=y, width=width, height=height)
SeekerBarrier(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("seekerBarrier", x=x, y=y, width=width, height=height)

TempleCrackedBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, persistent::Bool=false) = Entity("templeCrackedBlock", x=x, y=y, width=width, height=height, persistent=persistent)

BadelineFallingBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = Entity("fallingBlock", x=x, y=y, width=width, height=height, tiletype="g", finalBoss=true, behind=false, climbFall=false)
BadelineMovingBlock(x1::Integer, y1::Integer, x2::Integer=x1+16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, nodeIndex::Integer=0) = Entity("finalBossMovingBlock", x=x1, y=y1, nodes=[(x2, y2)], width=width, height=height, nodeIndex=nodeIndex)

Killbox(x::Integer, y::Integer, width::Integer) = Entity("killbox", x=x, y=y, width=width)

CliffsideFlag(x::Integer, y::Integer, index::Integer=0) = Entity("cliffside_flag", x=x, y=y, index=index)

Water(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, hasBottom::Bool=false) = Entity("water", x=x, y=y, width=width, height=height, hasBottom=hasBottom)
Waterfall(x::Integer, y::Integer) = Entity("waterfall", x=x, y=y)
BigWaterfall(x::Integer, y::Integer, height::Integer, layer::String="FG") = Entity("bigWaterfall", x=x, y=y, height=height, layer=layer)

HangingLamp(x::Integer, y::Integer, height::Integer=16) = Entity("hanginglamp", x=x, y=y, height=height)
Lamp(x::Integer, y::Integer, broken::Bool=false) = Entity("lamp", x=x, y=y, broken=broken)
BrokenLamp(x::Integer, y::Integer) = Entity("lamp", x=x, y=y, broken=true)
ResortLantern(x::Integer, y::Integer) = Entity("resortLantern", x=x, y=y)

Door(x::Integer, y::Integer, variant::String="wood") = Entity("door", Dict{String, Any}("x" => x, "y" => y, "type" => variant))
OshiroDoor(x::Integer, y::Integer) = Entity("oshirodoor", x=x, y=y)
TrapDoor(x::Integer, y::Integer) = Entity("trapdoor", x=x, y=y)

PicoConsole(x::Integer, y::Integer) = Entity("picoconsole", x=x, y=y)

SoundSource(x::Integer, y::Integer, sound::String="") = Entity("soundsource", x=x, y=y, sound=sound)

IntroCar(x::Integer, y::Integer) = Entity("introCar", x=x, y=y)

TempleEye(x::Integer, y::Integer) = Entity("templeEye", x=x, y=y)

Cloud(x::Integer, y::Integer, fragile::Bool=false) = Entity("cloud", x=x, y=y, fragile=fragile)
FragileCloud(x::Integer, y::Integer) = Cloud(x, y, true)

Spring(x::Integer, y::Integer, playerCanUse::Bool=true) = Entity("spring", x=x, y=y, playerCanUse=playerCanUse)
SpringRight(x::Integer, y::Integer) = Entity("wallSpringRight", x=x, y=y)
SpringLeft(x::Integer, y::Integer) = Entity("wallSpringLeft", x=x, y=y)

ColorSwitch(x::Integer, y::Integer, variant::String="red") = Entity("colorSwitch", Dict{String, Any}("x" => x, "y" => y, "type" => variant))
YellowBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, inverted::Bool=false) = Entity("yellowBlocks", x=x, y=y, width=width, height=height, inverted=inverted)
GreenBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, inverted::Bool=false) = Entity("greenBlocks", x=x, y=y, width=width, height=height, inverted=inverted)
RedBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, inverted::Bool=false) = Entity("redBlocks", x=x, y=y, width=width, height=height, inverted=inverted)
ClutterCabinet(x::Integer, y::Integer) = Entity("clutterCabinet", x=x, y=y)
ClutterDoor(x::Integer, y::Integer, width::Integer=24, height::Integer=24, variant::String="green") = Entity("clutterDoor", Dict{String, Any}("x" => x, "y" => y, "width" => width, "height" => height, "type" => variant))
ClutterSwitch = ColorSwitch

DashSwitchHorizontal(x::Integer, y::Integer, leftSide::Bool=false, persistent::Bool=false, sprite::String="default") = Entity("dashSwitchH", x=x, y=y, leftSide=leftSide, persistent=persistent, sprite=sprite)
DashSwitchVertical(x::Integer, y::Integer, ceiling::Bool=false, persistent::Bool=false, sprite::String="default") = Entity("dashSwitchV", x=x, y=y, ceiling=ceiling, persistent=persistent, sprite=sprite)
TempleGate(x::Integer, y::Integer, height::Integer=48, variant::String="NearestSwitch", sprite::String="default") = Entity("templeGate", Dict{String, Any}("x" => x, "y" => y, "height" => height, "type" => variant, "sprite" => sprite))
TheoCrystal(x::Integer, y::Integer) = Entity("theoCrystal", x=x, y=y)

Bumper(x::Integer, y::Integer) = Entity("bigSpinner", x=x, y=y)

Bonfire(x::Integer, y::Integer, mode::String="lit") = Entity("bonfire", x=x, y=y, mode=mode)
FriendlyGhost(x::Integer, y::Integer) = Entity("friendlyGhost", x=x, y=y)
OshiroBoss = FriendlyGhost

Key(x::Integer, y::Integer) = Entity("key", x=x, y=y)
LockBlock(x::Integer, y::Integer, sprite::String="wood") = Entity("lockBlock", x=x, y=y, sprite=sprite)

Flutterbird(x::Integer, y::Integer) = Entity("flutterbird", x=x, y=y)
Bird(x::Integer, y::Integer, mode::String="") = Entity("bird", x=x, y=y, mode=mode)

CoreMessage(x::Integer, y::Integer, line::Integer=0) = Entity("coreMessage", x=x, y=y, line=line)
EverestCoreMessage(x::Integer, y::Integer, line::Integer=0, dialog::String="app_ending") = Entity("everest/coreMessage", x=x, y=y, line=line, dialog=dialog)
Memorial(x::Integer, y::Integer, dreaming::Bool=false) = Entity("memorial", x=x, y=y, dreaming=dreaming)
EverestMemorial(x::Integer, y::Integer, dreaming::Bool=false, dialog::String="MEMORIAL", sprite::String="") = Entity("everest/memorial", x=x, y=y, dreaming=dreaming, dialog=dialog, sprite=sprite)

blacklistedEntityAttrs = String["nodes"]

function Base.Dict(e::Entity)
    res = Dict{String, Any}()
    res["__name"] = e.name
    res["id"] = e.id

    for (key, value) in e.data
        if !(key in blacklistedEntityAttrs)
            res[key] = value
        end
    end

    if haskey(e.data, "nodes")
        if length(e.data["nodes"]) > 0
            res["__children"] = Dict{String, Any}[]

            for node in e.data["nodes"]
                push!(res["__children"], Dict{String, Any}(
                    "__name" => "node",
                    "x" => node[1],
                    "y" => node[2]
                ))
            end
        end
    end

    if haskey(res, "variant")
        res["type"] = res["variant"]
        delete!(res, "variant")
    end

    return res
end
