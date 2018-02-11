using Parameters

@with_kw mutable struct Entity
    __name::String = "" # Entity Type

    x::Integer = 0
    y::Integer = 0

    originX::Integer = 0
    originY::Integer = 0

    width::Integer = 8
    height::Integer = 8

    texture::String = ""
    variant::String = "" # Use this for "type" field (used for spikes)
    sprite::String = "default"

    winged::Bool = false# Strawberries
    attached::Bool = false# Spinners

    red::Bool = false # Green/red orb

    requires::Integer = 0 # Core heart door

    startLit::Bool = false # Torches

    nodes::Array{Tuple{Integer, Integer}, 1} = Tuple{Integer, Integer}[] # Wires, dash activated blocks etc

    tiletype::String = "3" # Hidden walls etc

    steamy::Bool = false # Water

    fragile::Bool = false # Clouds

    blendin::Bool = true # Dashblock
    canDash::Bool = true # Dashblock
    permanent::Bool = true # Dashblock

    inverted::Bool = false # The toggleable blocks in Celestial Resort, doesn't seem to work

    speed::String = "Normal" # Moving Spinners
    startCenter::Bool = false # Moving Spinners

    clockwise::Bool = false # Circular Spinners

    playerCanUse::Bool = true # Springs

    persistent::Bool = false # Switch Gates¨

    left::Bool = false # Slippery slopes
    leftSide::Bool = false # Dash switches
    ceiling::Bool = false # Dash switches

    onlyIce::Bool = false # Core switches
    onlyFire::Bool = false # Core switches

    lockCamera::Bool = true # Badeline boost

    index::Integer = 0 # Casette blocks

    number::Integer = 0 # Summit Checkpoints

    singleUse::Bool = false # Feathers
    shielded::Bool = false # Feathers

    startHit::Bool = false # Badeline Boss
    patternIndex::Integer = 1 # Badeline Boss

    slide_until::Integer = 0 # Tentacles
    fear_distance::String = "close" # Tentacles

    rotation::Integer = 0 # Lightbeam

    climbFall::Bool = true # Falling blocks

    fastMoving::Bool = false # DreamBlock
end

#  *** Temple gate types ***
# CloseBehindPlayer
# NearestSwitch
# HoldingTheo
# TouchSwitches

Player(x::Integer, y::Integer) = Entity(__name="player", x=x, y=y, width=8)
DarkChaser(x::Integer, y::Integer) = Entity(__name="darkChaser", x=x, y=y)

function Strawberry(x::Integer, y::Integer, winged::Bool=false, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity(__name="strawberry", x=x, y=y, winged=winged, nodes=nodes)
end

function GoldenStrawberry(x::Integer, y::Integer, winged::Bool=false, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity(__name="goldenBerry", x=x, y=y, winged=winged, nodes=nodes)
end

function BadelineBoost(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], lockCamera::Bool=true) where {T <: Integer}
    return Entity(__name="badelineBoost", x=x, y=y, lockCamera=lockCamera, nodes=nodes)
end

function BadelineBoss(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], patternIndex::Integer=1, startHit::Bool=false) where {T <: Integer}
    return Entity(__name="finalBoss", x=x, y=y, startHit=startHit, nodes=nodes, patternIndex=patternIndex)
end

function Tentacles(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], fear_distance::String="close", slide_until::Integer=0) where {T <: Integer}
    return Entity(__name="tentacles", x=x, y=y, slide_until=slide_until, nodes=nodes, fear_distance=fear_distance)
end

Cassette(x1::Integer, y1::Integer, x2::Integer, y2::Integer) = Entity(__name="cassette", x=x1, y=y1, nodes=[(0, 0), (x2, y2)])

Towerviewer(x::Integer, y::Integer) = Entity(__name="towerviewer", x=x, y=y)

FloatingDebris(x::Integer, y::Integer) = Entity(__name="floatingDebris", x=x, y=y)
ForegroundDebris(x::Integer, y::Integer) = Entity(__name="foregroundDebris", x=x, y=y)

DreamMirror(x::Integer, y::Integer) = Entity(__name="dreammirror", x=x, y=y)

Refill(x::Integer, y::Integer) = Entity(__name="refill", x=x, y=y)
Feather(x::Integer, y::Integer, shielded::Bool=false, singleUse::Bool=false) = Entity(__name="infiniteStar", x=x, y=y, shielded=shielded, singleUse=singleUse)

Checkpoint(x::Integer, y::Integer) = Entity(__name="summitcheckpoint", x=x, y=y)
ChapterCheckpoint(x::Integer, y::Integer) = Entity(__name="checkpoint", x=x, y=y)

SpikesUp(x::Integer, y::Integer, width::Integer, variant::String="default") = Entity(__name="spikesUp", x=x, y=y, width=width, variant=variant)
SpikesDown(x::Integer, y::Integer, width::Integer, variant::String="default") = Entity(__name="spikesDown", x=x, y=y, width=width, variant=variant)
SpikesLeft(x::Integer, y::Integer, height::Integer, variant::String="default") = Entity(__name="spikesLeft", x=x, y=y, height=height, variant=variant)
SpikesRight(x::Integer, y::Integer, height::Integer, variant::String="default") = Entity(__name="spikesRight", x=x, y=y, height=height, variant=variant)

TriggerSpikesUp(x::Integer, y::Integer, width::Integer) = Entity(__name="triggerSpikesUp", x=x, y=y, width=width)
TriggerSpikesDown(x::Integer, y::Integer, width::Integer) = Entity(__name="triggerSpikesDown", x=x, y=y, width=width)
TriggerSpikesLeft(x::Integer, y::Integer, height::Integer) = Entity(__name="triggerSpikesLeft", x=x, y=y, height=height)
TriggerSpikesRight(x::Integer, y::Integer, height::Integer) = Entity(__name="triggerSpikesRight", x=x, y=y, height=height)

RotateSpinner(x1::Integer, y1::Integer, x2::Integer, y2::Integer, clockwise::Bool=false) = Entity(__name="rotateSpinner", x=x1, y=y1, nodes=[(x2, y2)], clockwise=clockwise)
Spinner(x::Integer, y::Integer, attached::Bool=false) = Entity(__name="spinner", x=x, y=y, attached=attached)
TrackSpinner(x1::Integer, y1::Integer, x2::Integer, y2::Integer, speed::String="Normal", startCenter::Bool=false) = Entity(__name="trackSpinner", x=x1, y=y1, nodes=[(x2, y2)], speed=speed, startCenter=startCenter)

JumpThru(x::Integer, y::Integer, width::Integer=8, texture::String="wood") = Entity(__name="jumpThru", x=x, y=y, width=width, texture=texture)

Booster(x::Integer, y::Integer, red::Bool=false) = Entity(__name="booster", x=x, y=y, red=red)
WallBooster(x::Integer, y::Integer, height::Integer, left::Bool=false) = Entity(__name="wallBooster", x=x, y=y, height=height, left=left)

Lightbeam(x::Integer, y::Integer, width::Integer, height::Integer, rotation::Integer=0) = Entity(__name="lightbeam", x=x, y=y, width=width, height=height, rotation=rotation)

Torch(x::Integer, y::Integer, startLit::Bool=false) = Entity(__name="torch", x=x, y=y, startLit=startLit)

Wire(x1::Integer, y1::Integer, x2::Integer, y2::Integer) = Entity(__name="wire", x=x1, y=y1, nodes=[(x2, y2)])
ClothesLine(x1::Integer, y1::Integer, x2::Integer, y2::Integer) = Entity(__name="clothesline", x=x1, y=y1, nodes=[(x2, y2)])

SwapBlock(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer, height::Integer) = Entity(__name="swapBlock", x=x1, y=y1, width=width, height=height, nodes=[(x2, y2)])

SwitchGate(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer, height::Integer, persistent::Bool=false, sprite::String="block") = Entity(__name="switchGate", x=x1, y=y1, width=width, height=height, nodes=[(x2, y2)], persistent=persistent, sprite=sprite)
TouchSwitch(x::Integer, y::Integer) = Entity(__name="touchSwitch", x=x, y=y)

SinkingPlatform(x::Integer, y::Integer, width::Integer) = Entity(__name="sinkingPlatform", x=x, y=y, width=width)
MovingPlatform(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer) = Entity(__name="movingPlatform", x=x1, y=y1, nodes=[(x2, y2)], width=width)

ZipMover(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer, height::Integer) = Entity(__name="zipMover", x=x1, y=y1, nodes=[(x2, y2)], width=width, height=height)

CoreFlag(x::Integer, y::Integer, onlyIce::Bool=false, onlyFire::Bool=false, persistent::Bool=false) = Entity(__name="coreModeToggle", x=x, y=y, onlyIce=onlyIce, onlyFire=onlyFire, persistent=persistent)

Checkpoint(x::Integer, y::Integer, number::Integer)  = Entity(__name="summitcheckpoint", x=x, y=y, number=number)

CrystalHeart(x::Integer, y::Integer)  = Entity(__name="blackGem", x=x, y=y)
HeartDoor(x::Integer, y::Integer, width::Integer, height::Integer, requires::Integer)  = Entity(__name="heartGemDoor", x=x, y=y, width=width, height=height, requires=requires)

CrumbleBlock(x::Integer, y::Integer, width::Integer)  = Entity(__name="crumbleBlock", x=x, y=y, width=width)
FakeWall(x::Integer, y::Integer, width::Integer, height::Integer, tiletype::String)  = Entity(__name="fakeWall", x=x, y=y, width=width, height=height, tiletype=tiletype)
FallingBlock(x::Integer, y::Integer, width::Integer, height::Integer, tiletype::String="3", climbFall::Bool=true)  = Entity(__name="fallingBlock", x=x, y=y, width=width, height=height, climbFall=climbFall, tiletype=tiletype)
CassetteBlock(x::Integer, y::Integer, width::Integer, height::Integer, index::Integer)  = Entity(__name="cassetteBlock", x=x, y=y, width=width, height=height, index=index)
DashBlock(x::Integer, y::Integer, width::Integer, height::Integer, tiletype::String="3", blendin::Bool=true, canDash::Bool=true, permanent::Bool=true)  = Entity(__name="dashBlock", x=x, y=y, width=width, height=height, tiletype=tiletype, blendin=blendin, canDash=canDash, permanent=permanent)
ExitBlock(x::Integer, y::Integer, width::Integer, height::Integer, tiletype::String="3")  = Entity(__name="exitBlock", x=x, y=y, width=width, height=height, tiletype=tiletype)

DreamBlock(x::Integer, y::Integer, width::Integer, height::Integer, fastMoving::Bool=false) = Entity(__name="dreamBlock", x=x, y=y, width=width, height=height, fastMoving=fastMoving)
DreamBlock(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer, height::Integer, fastMoving::Bool=false) = Entity(__name="dreamBlock", x=x1, y=y1, nodes=[(x2, y2)], width=width, height=height, fastMoving=fastMoving)

BlockField(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity(__name="blockField", x=x, y=y, width=width, height=height)

BounceBlock(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity(__name="bounceBlock", x=x, y=y, width=width, height=height)

WhiteBlock(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity(__name="whiteblock", x=x, y=y, width=width, height=height)

Barrier(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity(__name="invisibleBarrier", x=x, y=y, width=width, height=height)

BadelineBlock(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity(__name="finalBossFallingBlock", x=x, y=y, width=width, height=height)

Killbox(x::Integer, y::Integer, width::Integer)  = Entity(__name="killbox", x=x, y=y, width=width)

Water(x::Integer, y::Integer, width::Integer, height::Integer, steamy::Bool=false)  = Entity(__name="water", x=x, y=y, width=width, height=height, steamy=steamy)

HangingLamp(x::Integer, y::Integer, height::Integer=16) = Entity(__name="hanginglamp", x=x, y=y, height=height)
ResortLantern(x::Integer, y::Integer) = Entity(__name="resortLantern", x=x, y=y)

IntroCar(x::Integer, y::Integer) = Entity(__name="introCar", x=x, y=y)

Cloud(x::Integer, y::Integer, fragile::Bool=false) = Entity(__name="cloud", x=x, y=y, fragile=fragile)

Spring(x::Integer, y::Integer, playerCanUse::Bool=true) = Entity(__name="spring", x=x, y=y, playerCanUse=playerCanUse)

ColorSwitch(x::Integer, y::Integer, variant::String) = Entity(__name="colorSwitch", x=x, y=y, variant=variant)
YellowBlock(x::Integer, y::Integer, width::Integer, height::Integer, inverted::Bool=false) = Entity(__name="yellowBlocks", x=x, y=y, width=width, height=height, inverted=inverted)
GreenBlock(x::Integer, y::Integer, width::Integer, height::Integer, inverted::Bool=false) = Entity(__name="greenBlocks", x=x, y=y, width=width, height=height, inverted=inverted)
RedBlock(x::Integer, y::Integer, width::Integer, height::Integer, inverted::Bool=false) = Entity(__name="redBlocks", x=x, y=y, width=width, height=height, inverted=inverted)
ClutterCabinet(x::Integer, y::Integer) = Entity(__name="clutterCabinet", x=x, y=y)
ClutterDoor(x::Integer, y::Integer, width::Integer, height::Integer, variant::String) = Entity(__name="clutterDoor", x=x, y=y, width=width, height=height, variant=variant)

DashSwitchHorizontal(x::Integer, y::Integer, leftSide::Bool=false, persistent::Bool=true, sprite::String="default") = Entity(__name="dashSwitchH", x=x, y=y, leftSide=leftSide, persistent=persistent, sprite=sprite)
DashSwitchVertical(x::Integer, y::Integer, ceiling::Bool=false, persistent::Bool=true, sprite::String="default") = Entity(__name="dashSwitchV", x=x, y=y, ceiling=ceiling, persistent=persistent, sprite=sprite)
TempleGate(x::Integer, y::Integer, height::Integer=48, variant::String="NearestSwitch", sprite::String="default") = Entity(__name="templeGate", x=x, y=y, height=height, variant=variant, sprite=sprite)
TheoCrystal(x::Integer, y::Integer) = Entity(__name="theoCrystal", x=x, y=y)

entityIdSerial = 0
blacklistedEntityAttrs = String["nodes"]
noEntityDedup = String["x", "y"]
baseEntity = Entity()

function Base.Dict(e::Entity)
    res = Dict{String, Any}()

    for f in fieldnames(e)
        fs = string(f)
        value = getfield(e, f)

        if !(fs in blacklistedEntityAttrs) && (value != getfield(baseEntity, f) || fs in noEntityDedup)
            res[fs] = value
        end
    end

    res["id"] = entityIdSerial
    global entityIdSerial += 1

    if length(e.nodes) > 0
        res["__children"] = []

        for node in e.nodes
            push!(res["__children"], Dict(
                "__name" => "node",
                "x" => node[1],
                "y" => node[2]
            ))
        end
    end

    if haskey(res, "variant")
        res["type"] = res["variant"]
        delete!(res, "variant")
    end

    return res
end