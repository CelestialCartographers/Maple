entityIdSerial = 0

function nextEntityId()
    return global entityIdSerial += 1
end

@with_kw mutable struct Entity
    name::String = "" # Entity Type
    id::Integer = nextEntityId()

    data::Dict{String, Any} = Dict{String, Any}()
end

function Entity(name::String, data)
    return Entity(name=name, data=data)
end

Player(x::Integer, y::Integer) = Entity("player", Dict{String, Any}("x"=>x, "y"=>y, "width"=>8))
DarkChaser(x::Integer, y::Integer) = Entity("darkChaser", Dict{String, Any}("x"=>x, "y"=>y))

function Strawberry(x::Integer, y::Integer, winged::Bool=false, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity("strawberry", Dict{String, Any}("x"=>x, "y"=>y, "winged"=>winged, "nodes"=>nodes))
end

function GoldenStrawberry(x::Integer, y::Integer, winged::Bool=false, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity("goldenBerry", Dict{String, Any}("x"=>x, "y"=>y, "winged"=>winged, "nodes"=>nodes))
end

function BadelineBoost(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], lockCamera::Bool=true) where {T <: Integer}
    return Entity("badelineBoost", Dict{String, Any}("x"=>x, "y"=>y, "lockCamera"=>lockCamera, "nodes"=>nodes))
end

function BadelineBoss(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], patternIndex::Integer=1, startHit::Bool=false) where {T <: Integer}
    return Entity("finalBoss", Dict{String, Any}("x"=>x, "y"=>y, "startHit"=>startHit, "nodes"=>nodes, "patternIndex"=>patternIndex))
end

function Tentacles(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[], fear_distance::String="close", slide_until::Integer=0) where {T <: Integer}
    return Entity("tentacles", Dict{String, Any}("x"=>x, "y"=>y, "slide_until"=>slide_until, "nodes"=>nodes, "fear_distance"=>fear_distance))
end

function Cobweb(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity("cobweb", Dict{String, Any}("x"=>x, "y"=>y, "nodes"=>nodes))
end

function Seeker(x::Integer, y::Integer, nodes::Array{Tuple{T, T}, 1}=Tuple{Integer, Integer}[]) where {T <: Integer}
    return Entity("seeker", Dict{String, Any}("x"=>x, "y"=>y, "nodes"=>nodes))
end

Cassette(x1::Integer, y1::Integer, x2::Integer, y2::Integer) = Entity("cassette", Dict{String, Any}("x"=>x1, "y"=>y1, nodes=>[(0, 0), (x2, y2)]))

Towerviewer(x::Integer, y::Integer) = Entity("towerviewer", Dict{String, Any}("x"=>x, "y"=>y))

FloatingDebris(x::Integer, y::Integer) = Entity("floatingDebris", Dict{String, Any}("x"=>x, "y"=>y))
ForegroundDebris(x::Integer, y::Integer) = Entity("foregroundDebris", Dict{String, Any}("x"=>x, "y"=>y))

DreamMirror(x::Integer, y::Integer) = Entity("dreammirror", Dict{String, Any}("x"=>x, "y"=>y))

Refill(x::Integer, y::Integer) = Entity("refill", Dict{String, Any}("x"=>x, "y"=>y))
Feather(x::Integer, y::Integer, shielded::Bool=false, singleUse::Bool=false) = Entity("infiniteStar", Dict{String, Any}("x"=>x, "y"=>y, "shielded"=>shielded, "singleUse"=>singleUse))

Checkpoint(x::Integer, y::Integer) = Entity("summitcheckpoint", Dict{String, Any}("x"=>x, "y"=>y))
ChapterCheckpoint(x::Integer, y::Integer) = Entity("checkpoint", Dict{String, Any}("x"=>x, "y"=>y))

SpikesUp(x::Integer, y::Integer, width::Integer, variant::String="default") = Entity("spikesUp", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "variant"=>variant))
SpikesDown(x::Integer, y::Integer, width::Integer, variant::String="default") = Entity("spikesDown", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "variant"=>variant))
SpikesLeft(x::Integer, y::Integer, height::Integer, variant::String="default") = Entity("spikesLeft", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height, "variant"=>variant))
SpikesRight(x::Integer, y::Integer, height::Integer, variant::String="default") = Entity("spikesRight", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height, "variant"=>variant))

TriggerSpikesUp(x::Integer, y::Integer, width::Integer) = Entity("triggerSpikesUp", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width))
TriggerSpikesDown(x::Integer, y::Integer, width::Integer) = Entity("triggerSpikesDown", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width))
TriggerSpikesLeft(x::Integer, y::Integer, height::Integer) = Entity("triggerSpikesLeft", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height))
TriggerSpikesRight(x::Integer, y::Integer, height::Integer) = Entity("triggerSpikesRight", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height))

RotateSpinner(x1::Integer, y1::Integer, x2::Integer, y2::Integer, clockwise::Bool=false) = Entity("rotateSpinner", Dict{String, Any}("x"=>x1, "y"=>y1, nodes=>[(x2, y2)], "clockwise"=>clockwise))
Spinner(x::Integer, y::Integer, attached::Bool=false) = Entity("spinner", Dict{String, Any}("x"=>x, "y"=>y, "attached"=>attached))
TrackSpinner(x1::Integer, y1::Integer, x2::Integer, y2::Integer, speed::String="Normal", startCenter::Bool=false) = Entity("trackSpinner", Dict{String, Any}("x"=>x1, "y"=>y1, nodes=>[(x2, y2)], "speed"=>speed, "startCenter"=>startCenter))

JumpThru(x::Integer, y::Integer, width::Integer=8, texture::String="wood") = Entity("jumpThru", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "texture"=>texture))

Booster(x::Integer, y::Integer, red::Bool=false) = Entity("booster", Dict{String, Any}("x"=>x, "y"=>y, "red"=>red))
GreenBooster(x::Integer, y::Integer) = Booster(x, y, false) # Helper
RedBooster(x::Integer, y::Integer) = Booster(x, y, true) # Helper
WallBooster(x::Integer, y::Integer, height::Integer, left::Bool=false) = Entity("wallBooster", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height, "left"=>left))

Lightbeam(x::Integer, y::Integer, width::Integer, height::Integer, rotation::Integer=0) = Entity("lightbeam", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "rotation"=>rotation))

Torch(x::Integer, y::Integer, startLit::Bool=false) = Entity("torch", Dict{String, Any}("x"=>x, "y"=>y, "startLit"=>startLit))

Wire(x1::Integer, y1::Integer, x2::Integer, y2::Integer, above::Bool=false) = Entity("wire", Dict{String, Any}("x"=>x1, "y"=>y1, nodes=>[(x2, y2)], "above"=>above))
ClothesLine(x1::Integer, y1::Integer, x2::Integer, y2::Integer) = Entity("clothesline", Dict{String, Any}("x"=>x1, "y"=>y1, nodes=>[(x2, y2)]))

SwapBlock(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer, height::Integer) = Entity("swapBlock", Dict{String, Any}("x"=>x1, "y"=>y1, "width"=>width, "height"=>height, nodes=>[(x2, y2)]))

SwitchGate(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer, height::Integer, persistent::Bool=false, sprite::String="block") = Entity("switchGate", Dict{String, Any}("x"=>x1, "y"=>y1, "width"=>width, "height"=>height, nodes=>[(x2, y2)], "persistent"=>persistent, "sprite"=>sprite))
TouchSwitch(x::Integer, y::Integer) = Entity("touchSwitch", Dict{String, Any}("x"=>x, "y"=>y))

SinkingPlatform(x::Integer, y::Integer, width::Integer) = Entity("sinkingPlatform", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width))
MovingPlatform(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer) = Entity("movingPlatform", Dict{String, Any}("x"=>x1, "y"=>y1, nodes=>[(x2, y2)], "width"=>width))

ZipMover(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer, height::Integer) = Entity("zipMover", Dict{String, Any}("x"=>x1, "y"=>y1, nodes=>[(x2, y2)], "width"=>width, "height"=>height))

CoreFlag(x::Integer, y::Integer, onlyIce::Bool=false, onlyFire::Bool=false, persistent::Bool=false) = Entity("coreModeToggle", Dict{String, Any}("x"=>x, "y"=>y, "onlyIce"=>onlyIce, "onlyFire"=>onlyFire, "persistent"=>persistent))

Checkpoint(x::Integer, y::Integer, number::Integer)  = Entity("summitcheckpoint", Dict{String, Any}("x"=>x, "y"=>y, "number"=>number))

CrystalHeart(x::Integer, y::Integer)  = Entity("blackGem", Dict{String, Any}("x"=>x, "y"=>y))
HeartDoor(x::Integer, y::Integer, width::Integer, height::Integer, requires::Integer)  = Entity("heartGemDoor", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "requires"=>requires))

CrumbleBlock(x::Integer, y::Integer, width::Integer)  = Entity("crumbleBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width))
FakeWall(x::Integer, y::Integer, width::Integer, height::Integer, tiletype::String)  = Entity("fakeWall", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "tiletype"=>tiletype))
FallingBlock(x::Integer, y::Integer, width::Integer, height::Integer, tiletype::String="3", climbFall::Bool=true)  = Entity("fallingBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "climbFall"=>climbFall, "tiletype"=>tiletype))
CassetteBlock(x::Integer, y::Integer, width::Integer, height::Integer, index::Integer)  = Entity("cassetteBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "index"=>index))
DashBlock(x::Integer, y::Integer, width::Integer, height::Integer, tiletype::String="3", blendin::Bool=true, canDash::Bool=true, permanent::Bool=true)  = Entity("dashBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "tiletype"=>tiletype, "blendin"=>blendin, "canDash"=>canDash, "permanent"=>permanent))
ExitBlock(x::Integer, y::Integer, width::Integer, height::Integer, tiletype::String="3")  = Entity("exitBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "tiletype"=>tiletype))
NegaBlock(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity("negaBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height))
MoveBlock(x::Integer, y::Integer, width::Integer, height::Integer, direction::String="Up", canSteer::Bool=false, fast::Bool=false)  = Entity("moveBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "direction"=>direction, "canSteer"=>canSteer, "fast"=>fast))


DreamBlock(x::Integer, y::Integer, width::Integer, height::Integer) = Entity("dreamBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height))
DreamBlock(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer, height::Integer, fastMoving::Bool=false) = Entity("dreamBlock", Dict{String, Any}("x"=>x1, "y"=>y1, nodes=>[(x2, y2)], "width"=>width, "height"=>height, "fastMoving"=>fastMoving))
SpaceJam = DreamBlock

StarJumpController(x::Integer, y::Integer) = Entity("starClimbController", Dict{String, Any}("x"=>x, "y"=>y))
StarJumpBlock(x::Integer, y::Integer, width::Integer, height::Integer, sinks::Bool=true) = Entity("starJumpBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "sinks"=>sinks))

BlockField(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity("blockField", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height))
StrawberryBlockField = BlockField

BounceBlock(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity("bounceBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height))

WhiteBlock(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity("whiteblock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height))

Barrier(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity("invisibleBarrier", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height))
SeekerBarrier(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity("seekerBarrier", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height))

TempleCrackedBlock(x::Integer, y::Integer, width::Integer, height::Integer, persistent::Bool=false)  = Entity("templeCrackedBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "persistent"=>persistent))

BadelineBlock(x::Integer, y::Integer, width::Integer, height::Integer)  = Entity("finalBossFallingBlock", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height))

Killbox(x::Integer, y::Integer, width::Integer)  = Entity("killbox", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width))

Water(x::Integer, y::Integer, width::Integer, height::Integer, steamy::Bool=false)  = Entity("water", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "steamy"=>steamy))
Waterfall(x::Integer, y::Integer) = Entity("waterfall", Dict{String, Any}("x"=>x, "y"=>y))
BigWaterfall(x::Integer, y::Integer, height::Integer, layer::String="FG") = Entity("bigWaterfall", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height, "layer"=>layer))

HangingLamp(x::Integer, y::Integer, height::Integer=16) = Entity("hanginglamp", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height))
ResortLantern(x::Integer, y::Integer) = Entity("resortLantern", Dict{String, Any}("x"=>x, "y"=>y))

Door(x::Integer, y::Integer, variant::String="wood") = Entity("door", Dict{String, Any}("x"=>x, "y"=>y, "variant"=>variant))
OshiroDoor(x::Integer, y::Integer) = Entity("oshirodoor", Dict{String, Any}("x"=>x, "y"=>y))
TrapDoor(x::Integer, y::Integer) = Entity("trapdoor", Dict{String, Any}("x"=>x, "y"=>y))

PicoConsole(x::Integer, y::Integer) = Entity("picoconsole", Dict{String, Any}("x"=>x, "y"=>y))

SoundSource(x::Integer, y::Integer, sound::String) = Entity("soundsource", Dict{String, Any}("x"=>x, "y"=>y, "sound"=>sound))

IntroCar(x::Integer, y::Integer) = Entity("introCar", Dict{String, Any}("x"=>x, "y"=>y))

Cloud(x::Integer, y::Integer, fragile::Bool=false) = Entity("cloud", Dict{String, Any}("x"=>x, "y"=>y, "fragile"=>fragile))

Spring(x::Integer, y::Integer, playerCanUse::Bool=true) = Entity("spring", Dict{String, Any}("x"=>x, "y"=>y, "playerCanUse"=>playerCanUse))
SpringRight(x::Integer, y::Integer) = Entity("wallSpringRight", Dict{String, Any}("x"=>x, "y"=>y))
SpringLeft(x::Integer, y::Integer) = Entity("wallSpringLeft", Dict{String, Any}("x"=>x, "y"=>y))

ColorSwitch(x::Integer, y::Integer, variant::String) = Entity("colorSwitch", Dict{String, Any}("x"=>x, "y"=>y, "variant"=>variant))
YellowBlock(x::Integer, y::Integer, width::Integer, height::Integer, inverted::Bool=false) = Entity("yellowBlocks", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "inverted"=>inverted))
GreenBlock(x::Integer, y::Integer, width::Integer, height::Integer, inverted::Bool=false) = Entity("greenBlocks", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "inverted"=>inverted))
RedBlock(x::Integer, y::Integer, width::Integer, height::Integer, inverted::Bool=false) = Entity("redBlocks", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "inverted"=>inverted))
ClutterCabinet(x::Integer, y::Integer) = Entity("clutterCabinet", Dict{String, Any}("x"=>x, "y"=>y))
ClutterDoor(x::Integer, y::Integer, width::Integer, height::Integer, variant::String) = Entity("clutterDoor", Dict{String, Any}("x"=>x, "y"=>y, "width"=>width, "height"=>height, "variant"=>variant))

DashSwitchHorizontal(x::Integer, y::Integer, leftSide::Bool=false, persistent::Bool=true, sprite::String="default") = Entity("dashSwitchH", Dict{String, Any}("x"=>x, "y"=>y, "leftSide"=>leftSide, "persistent"=>persistent, "sprite"=>sprite))
DashSwitchVertical(x::Integer, y::Integer, ceiling::Bool=false, persistent::Bool=true, sprite::String="default") = Entity("dashSwitchV", Dict{String, Any}("x"=>x, "y"=>y, "ceiling"=>ceiling, "persistent"=>persistent, "sprite"=>sprite))
TempleGate(x::Integer, y::Integer, height::Integer=48, variant::String="NearestSwitch", sprite::String="default") = Entity("templeGate", Dict{String, Any}("x"=>x, "y"=>y, "height"=>height, "variant"=>variant, "sprite"=>sprite))
TheoCrystal(x::Integer, y::Integer) = Entity("theoCrystal", Dict{String, Any}("x"=>x, "y"=>y))

Bumper(x::Integer, y::Integer) = Entity("bigSpinner", Dict{String, Any}("x"=>x, "y"=>y))

Bonfire(x::Integer, y::Integer, mode::String="lit") = Entity("bonfire", Dict{String, Any}("x"=>x, "y"=>y, "mode"=>mode))
FriendlyGhost(x::Integer, y::Integer) = Entity("friendlyGhost", Dict{String, Any}("x"=>x, "y"=>y))
OshiroBoss = FriendlyGhost

Key(x::Integer, y::Integer) = Entity("key", Dict{String, Any}("x"=>x, "y"=>y))
LockBlock(x::Integer, y::Integer, sprite::String="wood") = Entity("lockBlock", Dict{String, Any}("x"=>x, "y"=>y, "sprite"=>sprite))

Flutterbird(x::Integer, y::Integer) = Entity("flutterbird", Dict{String, Any}("x"=>x, "y"=>y))
Bird(x::Integer, y::Integer, mode::String="") = Entity("bird", Dict{String, Any}("x"=>x, "y"=>y, "mode"=>mode))

CoreMessage(x::Integer, y::Integer, line::Integer, dialog::String="app_ending") = Entity("coreMessage", Dict{String, Any}("x"=>x, "y"=>y, "line"=>line, "dialog"=>dialog))

blacklistedEntityAttrs = String["nodes", "name"]

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
            res["__children"] = []

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
