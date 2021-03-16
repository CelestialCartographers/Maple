# Don't care about the ID when comparing
@valueequals [id] @fieldproxy mutable struct Entity{T}
    name::String
    data::Dict{String, Any}

    id::Integer

    Entity{T}(name::String, data::Dict{String, Any}, id::Integer=nextEntityId()) where T = new{T}(name, data, id)
    Entity{T}(name::String, id::Integer=nextEntityId(); kwargs...) where T = new{T}(name, Dict{String, Any}(String(k) => v for (k, v) in kwargs), id)

    Entity(name::String, data::Dict{String, Any}, id::Integer=nextEntityId()) = new{Symbol(name)}(name, data, id)
    Entity(name::String, id::Integer=nextEntityId(); kwargs...) = new{Symbol(name)}(name, Dict{String, Any}(String(k) => v for (k, v) in kwargs), id)
end

entityIdSerial = 0

const defaultBlockWidth = 16
const defaultBlockHeight = 16

const defaultSpikeWidth = 8
const defaultSpikeHeight = 8

function nextEntityId()
    return global entityIdSerial += 1
end


@mapdef Entity "player" Player(x::Integer, y::Integer)
@mapdef Entity "darkChaser" DarkChaser(x::Integer, y::Integer, canChangeMusic::Bool=true)
BadelineChaser = DarkChaser

# Added by Everest to make Dark Chasers useable by custom maps
@mapdef Entity "darkChaserEnd" DarkChaserEnd(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)
DarkChaserBarrier = DarkChaserEnd
BadelineChaserEnd = DarkChaserEnd
BadelineChaserBarrier = DarkChaserEnd

@mapdef Entity "strawberry" Strawberry(x::Integer, y::Integer, winged::Bool=false, moon::Bool=false, checkpointID::Integer=-1, order::Integer=-1, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
@mapdef Entity "goldenBerry" GoldenStrawberry(x::Integer, y::Integer, winged::Bool=false, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
@mapdef Entity "memorialTextController" MemorialTextController(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
GoldenStrawberryNoDash = MemorialTextController

@mapdef Entity "badelineBoost" BadelineBoost(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[], lockCamera::Bool=true, canSkip::Bool=false, finalCh9Boost::Bool=false, finalCh9GoldenBoost::Bool=false, finalCh9Dialog::Bool=false)
@mapdef Entity "finalBoss" BadelineBoss(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[], patternIndex::Integer=1, startHit::Bool=false, cameraPastY::Number=120.0, cameraLockY::Bool=true, canChangeMusic::Bool=true)

FinalBoss = BadelineBoss

@mapdef Entity "fireBall" FireBall(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[], amount::Integer=1, offset::Number=0.0, speed::Number=1.0, notCoreMode::Bool=false)

@mapdef Entity "tentacles" Tentacles(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[], fear_distance::String="", slide_until::Integer=0)

# Cobweb color exposed by Everest
@mapdef Entity "cobweb" Cobweb(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[], color::String="696A6A")

@mapdef Entity "seeker" Seeker(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
@mapdef Entity "seekerStatue" SeekerStatue(x::Integer, y::Integer, hatch::String="Distance", nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])

@mapdef Entity "playerSeeker" PlayerSeeker(x::Integer, y::Integer)

@pardef Cassette(x1::Integer, y1::Integer, x2::Integer=x1, y2::Integer=y1) = Entity("cassette", x=x1, y=y1, nodes=Tuple{Int, Int}[(0, 0), (x2, y2)])

@mapdef Entity "towerviewer" Towerviewer(x::Integer, y::Integer, summit::Bool=false, onlyY::Bool=false)
Lookout = Towerviewer

@mapdef Entity "floatingDebris" FloatingDebris(x::Integer, y::Integer)
@mapdef Entity "foregroundDebris" ForegroundDebris(x::Integer, y::Integer)

@mapdef Entity "dreammirror" DreamMirror(x::Integer, y::Integer)
@mapdef Entity "resortmirror" ResortMirror(x::Integer, y::Integer)
@mapdef Entity "templeMirror" TempleMirror(x::Integer, y::Integer, reflectX::Number=0.0, reflectY::Number=0.0)

@mapdef Entity "refill" Refill(x::Integer, y::Integer, twoDash::Bool=false, oneUse::Bool=false)
@mapdef Entity "infiniteStar" Feather(x::Integer, y::Integer, shielded::Bool=false, singleUse::Bool=false)

# Everest needs null values here for automatic fills
# Inventory and Dreaming has to be nullable, -1 for checkpointID is considered null
@mapdef Entity "checkpoint" ChapterCheckpoint(x::Integer, y::Integer, inventory::Union{String, Nothing}=nothing, dreaming::Union{Bool, Nothing}=nothing, coreMode::Union{String, Nothing}=nothing, checkpointID::Integer=-1, bg::String=""; allowOrigin::Bool=false)

@mapdef Entity "summitcheckpoint" Checkpoint(x::Integer, y::Integer, number::Integer=0)

@mapdef Entity "spikesUp" SpikesUp(x::Integer, y::Integer, width::Integer=defaultSpikeWidth, type::String="default")
@mapdef Entity "spikesDown" SpikesDown(x::Integer, y::Integer, width::Integer=defaultSpikeWidth, type::String="default")
@mapdef Entity "spikesLeft" SpikesLeft(x::Integer, y::Integer, height::Integer=defaultSpikeHeight, type::String="default")
@mapdef Entity "spikesRight" SpikesRight(x::Integer, y::Integer, height::Integer=defaultSpikeHeight, type::String="default")

@mapdef Entity "triggerSpikesUp" TriggerSpikesUp(x::Integer, y::Integer, width::Integer=defaultSpikeWidth)
@mapdef Entity "triggerSpikesDown" TriggerSpikesDown(x::Integer, y::Integer, width::Integer=defaultSpikeWidth)
@mapdef Entity "triggerSpikesLeft" TriggerSpikesLeft(x::Integer, y::Integer, height::Integer=defaultSpikeHeight)
@mapdef Entity "triggerSpikesRight" TriggerSpikesRight(x::Integer, y::Integer, height::Integer=defaultSpikeHeight)

# Added by Everest
@mapdef Entity "triggerSpikesOriginalUp" TriggerSpikesOriginalUp(x::Integer, y::Integer, width::Integer=defaultSpikeWidth, type::String="default")
@mapdef Entity "triggerSpikesOriginalDown" TriggerSpikesOriginalDown(x::Integer, y::Integer, width::Integer=defaultSpikeWidth, type::String="default")
@mapdef Entity "triggerSpikesOriginalLeft" TriggerSpikesOriginalLeft(x::Integer, y::Integer, height::Integer=defaultSpikeHeight, type::String="default")
@mapdef Entity "triggerSpikesOriginalRight" TriggerSpikesOriginalRight(x::Integer, y::Integer, height::Integer=defaultSpikeHeight, type::String="default")

@mapdef Entity "spinner" Spinner(x::Integer, y::Integer, attachToSolid::Bool=false)

# Star and Dust added by Everest
@pardef TrackSpinner(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, speed::String="Normal", startCenter::Bool=false, dust::Bool=false, star::Bool=false) = Entity("trackSpinner", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], speed=speed, startCenter=startCenter, dust=dust, star)
@pardef RotateSpinner(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, clockwise::Bool=false, dust::Bool=false, star::Bool=false) = Entity("rotateSpinner", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], clockwise=clockwise, dust=dust, star=star)

@mapdef Entity "jumpThru" JumpThru(x::Integer, y::Integer, width::Integer=8, texture::String="wood", surfaceIndex::Int=-1)

@mapdef Entity "wallBooster" WallBooster(x::Integer, y::Integer, height::Integer=8, left::Bool=false, notCoreMode::Bool=false)
@mapdef Entity "booster" Booster(x::Integer, y::Integer, red::Bool=false, ch9_hub_booster::Bool=false)
GreenBooster(x::Integer, y::Integer) = Booster(x, y, false) # Helper
RedBooster(x::Integer, y::Integer) = Booster(x, y, true) # Helper

@mapdef Entity "lightbeam" Lightbeam(x::Integer, y::Integer, width::Integer=32, height::Integer=24, flag::String="", rotation::Integer=0)

@mapdef Entity "torch" Torch(x::Integer, y::Integer, startLit::Bool=false)

# Wire color exposed by Everest
@pardef Wire(x1::Integer, y1::Integer, x2::Integer=x1 + 8, y2::Integer=y1, above::Bool=false, color::String="595866") = Entity("wire", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], above=above, color=color)
@pardef ClothesLine(x1::Integer, y1::Integer, x2::Integer=x1 + 8, y2::Integer=y1) = Entity("clothesline", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)])
@pardef CliffFlags(x1::Integer, y1::Integer, x2::Integer=x1 + 8, y2::Integer=y1) = Entity("cliffflag", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)])
FlagLine = CliffFlags

@pardef SwapBlock(x1::Integer, y1::Integer, x2::Integer=x1+16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, theme="Normal") = Entity("swapBlock", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], width=width, height=height, theme=theme)
MoonSwapBlock(x1::Integer, y1::Integer, x2::Integer=x1+16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight) = SwapBlock(x1, y1, x2, y2, width, height, "Moon")

@pardef SwitchGate(x1::Integer, y1::Integer, x2::Integer=x1+16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, persistent::Bool=false, sprite::String="block") = Entity("switchGate", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], width=width, height=height, persistent=persistent, sprite=sprite)
@mapdef Entity "touchSwitch" TouchSwitch(x::Integer, y::Integer)

# Texture exposed by Everest
@mapdef Entity "sinkingPlatform" SinkingPlatform(x::Integer, y::Integer, width::Integer=defaultBlockWidth, texture::String="default")
@pardef MovingPlatform(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, width::Integer=defaultBlockWidth, texture::String="default") = Entity("movingPlatform", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], width=width, texture=texture)

@pardef ZipMover(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockWidth, theme="Normal") = Entity("zipMover", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], width=width, height=height, theme=theme)
MoonZipMover(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockWidth) = Zipmover(x1, y1, x2, y2, width, height, "Moon")

@mapdef Entity "coreModeToggle" CoreFlag(x::Integer, y::Integer, onlyIce::Bool=false, onlyFire::Bool=false, persistent::Bool=false)

@mapdef Entity "slider" Slider(x::Integer, y::Integer, clockwise::Bool=true, surface::String="Floor")

@mapdef Entity "blackGem" CrystalHeart(x::Integer, y::Integer, fake::Bool=false, removeCameraTriggers::Bool=false, fakeHeartDialog::String="CH9_FAKE_HEART", keepGoingDialog::String="CH9_KEEP_GOING")
@mapdef Entity "fakeHeart" FakeCrystalHeart(x::Integer, y::Integer, color::String="Random")
@mapdef Entity "dreamHeartGem" DreamCrystalHeart(x::Integer, y::Integer)
@mapdef Entity "heartGemDoor" HeartDoor(x::Integer, y::Integer, width::Integer=40, requires::Integer=0, startHidden::Bool=false)

@mapdef Entity "plateau" Plateau(x::Integer, y::Integer)
@mapdef Entity "resortRoofEnding" ResortRoofEnding(x::Integer, y::Integer, width::Integer=defaultBlockWidth)

# CrumbleBlock texture exposed by Everest
@mapdef Entity "crumbleBlock" CrumbleBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, texture::String="default")
@mapdef Entity "fakeWall" FakeWall(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3")
@mapdef Entity "floatySpaceBlock" FloatySpaceBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3", disableSpawnOffset::Bool=false)
@mapdef Entity "crumbleWallOnRumble" CrumbleWallOnRumble(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="m", blendin::Bool=true, persistent::Bool=false)
@mapdef Entity "fakeBlock" FakeBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3", playTransitionReveal::Bool=false)
@mapdef Entity "exitBlock" ExitBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tileType::String="3", playTransitionReveal::Bool=false)
@mapdef Entity "conditionBlock" ConditionBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tileType::String="3", condition::String="Key", conditionID::String="1:1")
@mapdef Entity "coverupWall" CoverupWall(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3")
@mapdef Entity "dashBlock" DashBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3", blendin::Bool=true, canDash::Bool=true, permanent::Bool=true)
@mapdef Entity "fallingBlock" FallingBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3", climbFall::Bool=true, behind::Bool=false)
@mapdef Entity "finalBossFallingBlock" BadelineFallingBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)

@mapdef Entity "introCrusher" IntroCrusher(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, tiletype::String="3", flags::String="1,0b")

# Is actually not resizable, but still has a width for collision purposes
@pardef RidgeGate(x1::Integer, y1::Integer, x2::Integer=x1 + 16, y2::Integer=y1, strawberries::String="", keys::String="", texture::String="objects/ridgeGate") = Entity("ridgeGate", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], width=32, height=32, strawberries=strawberries, keys=keys, texture=texture)

@mapdef Entity "cassetteBlock" CassetteBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, index::Integer=0, tempo::Number=1.0)
@mapdef Entity "negaBlock" NegaBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)
@mapdef Entity "moveBlock" MoveBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, direction::String="Up", canSteer::Bool=false, fast::Bool=false)
@mapdef Entity "crushBlock" CrushBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, axes::String="both", chillout::Bool=false)
KevinBlock = CrushBlock

@mapdef Entity "iceBlock" IceBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)
@mapdef Entity "fireBarrier" FireBarrier(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)

@mapdef Entity "dreamBlock" DreamBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, fastMoving::Bool=false, oneUse::Bool=false, below::Bool=false)
@mapdef false Entity "dreamBlock" MovingDreamBlock(x1::Integer, y1::Integer, x2::Integer, y2::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, fastMoving::Bool=false, oneUse::Bool=false, below::Bool=false)
SpaceJam = DreamBlock
MovingSpaceJam = MovingDreamBlock

@mapdef Entity "starJumpBlock" StarJumpBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, sinks::Bool=true)
@mapdef Entity "starClimbController" StarJumpController(x::Integer, y::Integer)
@mapdef Entity "everest/starClimbGraphicsController" StarJumpClimbGraphicsController(x::Integer, y::Integer, fgColor::String="A3FFFF", bgColor::String="293E4B")
StarClimbController = StarJumpController
StarClimbGraphicsController = StarJumpClimbGraphicsController

@mapdef Entity "blockField" BlockField(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)
StrawberryBlockField = BlockField

@mapdef Entity "bounceBlock" BounceBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, notCoreMode::Bool=false)

@mapdef Entity "whiteblock" WhiteBlock(x::Integer, y::Integer)
@mapdef Entity "goldenBlock" GoldenBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)

@mapdef Entity "invisibleBarrier" Barrier(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)
@mapdef Entity "seekerBarrier" SeekerBarrier(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)

@mapdef Entity "templeCrackedBlock" TempleCrackedBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, persistent::Bool=false)
@mapdef Entity "templeMirrorPortal" TempleMirrorPortal(x::Integer, y::Integer)

@pardef BadelineMovingBlock(x1::Integer, y1::Integer, x2::Integer=x1+16, y2::Integer=y1, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, nodeIndex::Integer=0) = Entity("finalBossMovingBlock", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], width=width, height=height, nodeIndex=nodeIndex)

@mapdef Entity "killbox" Killbox(x::Integer, y::Integer, width::Integer=defaultBlockWidth)

@mapdef Entity "cliffside_flag" CliffsideFlag(x::Integer, y::Integer, index::Integer=0)

@mapdef Entity "water" Water(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, hasBottom::Bool=false)
@mapdef Entity "waterfall" Waterfall(x::Integer, y::Integer)
@mapdef Entity "bigWaterfall" BigWaterfall(x::Integer, y::Integer, width::Integer=16, height::Integer=64, layer::String="FG")

@mapdef Entity "hanginglamp" HangingLamp(x::Integer, y::Integer, height::Integer=16)
@mapdef Entity "resortLantern" ResortLantern(x::Integer, y::Integer)
@mapdef Entity "lamp" Lamp(x::Integer, y::Integer, broken::Bool=false)
BrokenLamp(x::Integer, y::Integer) = Lamp(x, y, true) # Helper

@mapdef Entity "door" Door(x::Integer, y::Integer, type::String="wood")
@mapdef Entity "oshirodoor" OshiroDoor(x::Integer, y::Integer)
@mapdef Entity "trapdoor" Trapdoor(x::Integer, y::Integer)

@mapdef Entity "picoconsole" PicoConsole(x::Integer, y::Integer)

@mapdef Entity "soundSource" SoundSource(x::Integer, y::Integer, sound::String="")

@mapdef Entity "introCar" IntroCar(x::Integer, y::Integer, hasRoadAndBarriers::Bool=false)
@pardef Gondola(x::Integer, y::Integer, stopX::Integer=x+128, stopY::Integer=y-128, active::Bool=true) = Entity("gondola", x=x, y=y, nodes=Tuple{Int, Int}[(stopX, stopY)])

@mapdef Entity "templeEye" TempleEye(x::Integer, y::Integer)
@mapdef Entity "templeBigEyeball" TempleBigEyeball(x::Integer, y::Integer)
TempleBigEye = TempleBigEyeball

@mapdef Entity "summitcloud" SummitCloud(x::Integer, y::Integer)
@mapdef Entity "cloud" Cloud(x::Integer, y::Integer, fragile::Bool=false, small::Bool=false)
FragileCloud(x::Integer, y::Integer, small::Bool=false) = Cloud(x, y, true, small)

@mapdef Entity "spring" Spring(x::Integer, y::Integer, playerCanUse::Bool=true)
@mapdef Entity "wallSpringRight" SpringRight(x::Integer, y::Integer, playerCanUse::Bool=true)
@mapdef Entity "wallSpringLeft" SpringLeft(x::Integer, y::Integer, playerCanUse::Bool=true)

@mapdef Entity "colorSwitch" ColorSwitch(x::Integer, y::Integer, type::String="red")
@mapdef Entity "yellowBlocks" YellowBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)
@mapdef Entity "greenBlocks" GreenBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)
@mapdef Entity "redBlocks" RedBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)
@mapdef Entity "clutterCabinet" ClutterCabinet(x::Integer, y::Integer)
@mapdef Entity "clutterDoor" ClutterDoor(x::Integer, y::Integer, width::Integer=24, height::Integer=24, type::String="green")
ClutterSwitch = ColorSwitch

@mapdef Entity "dashSwitchH" DashSwitchHorizontal(x::Integer, y::Integer, leftSide::Bool=false, persistent::Bool=false, sprite::String="default")
@mapdef Entity "dashSwitchV" DashSwitchVertical(x::Integer, y::Integer, ceiling::Bool=false, persistent::Bool=false, sprite::String="default")
@mapdef Entity "templeGate" TempleGate(x::Integer, y::Integer, height::Integer=48, type::String="NearestSwitch", sprite::String="default")

@mapdef Entity "theoCrystalPedestal" TheoCrystalPedestal(x::Integer, y::Integer)
@mapdef Entity "theoCrystal" TheoCrystal(x::Integer, y::Integer)

@mapdef Entity "bigSpinner" Bumper(x::Integer, y::Integer)

@mapdef Entity "bonfire" Bonfire(x::Integer, y::Integer, mode::String="Lit")
@mapdef Entity "friendlyGhost" FriendlyGhost(x::Integer, y::Integer)
OshiroBoss = FriendlyGhost

@mapdef Entity "key" Key(x::Integer, y::Integer)
@mapdef Entity "lockBlock" LockBlock(x::Integer, y::Integer, sprite::String="wood", unlock_sfx::String="", stepMusicProgress::Bool=false)

@mapdef Entity "flutterbird" Flutterbird(x::Integer, y::Integer)
@mapdef Entity "bird" Bird(x::Integer, y::Integer, mode::String="Sleeping", onlyOnce::Bool=false, onlyIfPlayerLeft::Bool=false, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
@pardef Hahaha(x1::Integer, y1::Integer, x2::Integer=x1+16, y2::Integer=y1, ifset::String="", triggerLaughSfx::Bool=false) = Entity("hahaha", x=x1, y=y1, nodes=Tuple{Int, Int}[(x2, y2)], ifset=ifset, triggerLaughSfx=triggerLaughSfx)
@mapdef Entity "npc" NPC(x::Integer, y::Integer, npc::String="granny_00_house")
Npc = NPC

@mapdef Entity "SummitBackgroundManager" SummitBackgroundManager(x::Integer, y::Integer, index::Integer=0, cutscene::String="", intro_launch::Bool=false, dark::Bool=false, ambience::String="")

@mapdef Entity "cutsceneNode" CutsceneNode(x::Integer, y::Integer, nodeName::String="")

@mapdef Entity "everest/npc" EverestCustomNPC(x::Integer, y::Integer, sprite::String="player/idle", spriteRate::Int=1, dialogId::String="", onlyOnce::Bool=true, endLevel::Bool=false, flipX::Bool=false, flipY::Bool=false, approachWhenTalking::Bool=false, approachDistance::Int=16, indicatorOffsetX::Int=0, indicatorOffsetY::Int=0)
EverestCustomNpc = EverestCustomNPC

@pardef ReflectionHeartStatue(x::Integer, y::Integer, hintX1::Integer=x+32, hintY1::Integer=y, hintX2::Integer=x+64, hintY2::Integer=y, hintX3::Integer=x+96, hintY3::Integer=y, hintX4::Integer=x+128, hintY4::Integer=y, gemX::Integer=x, gemY::Integer=y-64) = Entity("reflectionHeartStatue", x=x, y=y, nodes=Tuple{Int, Int}[(hintX1, hintY1), (hintX2, hintY2), (hintX3, hintY3), (hintX4, hintY4), (gemX, gemY)])
@pardef BirdForsakenCityGem(x::Integer, y::Integer, birdX::Integer=x+64, birdY::Integer=y, gemX::Integer=x+48, gemY::Integer=y) = Entity("birdForsakenCityGem", x=x, y=y, nodes=Tuple{Int, Int}[(birdX, birdY), (gemX, gemY)])
ForsakenCitySatellite = BirdForsakenCityGem

@mapdef Entity "coreMessage" CoreMessage(x::Integer, y::Integer, line::Integer=0)
@mapdef Entity "everest/coreMessage" EverestCoreMessage(x::Integer, y::Integer, line::Integer=0, dialog::String="app_ending", outline::Bool=false)
@mapdef Entity "memorial" Memorial(x::Integer, y::Integer)
@mapdef Entity "everest/memorial" EverestMemorial(x::Integer, y::Integer, dialog::String="MEMORIAL", sprite::String="scenery/memorial/memorial", spacing::Integer=16)

@mapdef Entity "payphone" Payphone(x::Integer, y::Integer)

@mapdef Entity "risingLava" RisingLava(x::Integer, y::Integer, intro::Bool=false)
@mapdef Entity "sandwichLava" SandwichLava(x::Integer, y::Integer)

@pardef Bridge(x::Integer, y::Integer, width::Integer=32, gapStartX::Integer=x+96, gapStopX::Integer=x+128) = Entity("bridge", x=x, y=y, width=width, nodes=Tuple{Int, Int}[(gapStartX, y), (gapStopX, y)])
@mapdef Entity "bridgeFixed" BridgeFixed(x::Integer, y::Integer, width::Integer=32)

@mapdef Entity "glassBlock" GlassBlock(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, sinks::Bool=false)

@mapdef Entity "summitgem" SummitGem(x::Integer, y::Integer, gem::Integer=0)
@mapdef Entity "summitGemManager" SummitGemManager(x::Integer, y::Integer)

@mapdef Entity "moonCreature" MoonCreature(x::Integer, y::Integer, number::Integer=1)

@mapdef Entity "glider" Glider(x::Integer, y::Integer, bubble::Bool=false, tutorial::Bool=false)
Jellyfish = Glider

@mapdef Entity "eyebomb" Puffer(x::Integer, y::Integer, right::Bool=false)

@mapdef Entity "lightning" Lightning(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight, perLevel::Bool=false, moveTime::Number=5.0, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])
@mapdef Entity "lightningBlock" LightningBreakerBox(x::Integer, y::Integer, flipX::Bool=false, music_progress::Integer=-1, music_session::Bool=false, music::String="", flag::Bool=false)

@mapdef Entity "birdPath" BirdPath(x::Integer, y::Integer, only_once::Bool=false, onlyIfLeft::Bool=false, speedMult::Number=1.0)
@mapdef Entity "flingBird" FlingBird(x::Integer, y::Integer, waiting::Bool=false)
@mapdef Entity "flingBirdIntro" FlingBirdIntro(x::Integer, y::Integer, nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])

@mapdef Entity "playbackBillboard" PlaybackBillboard(x::Integer, y::Integer, width::Integer=defaultBlockWidth, height::Integer=defaultBlockHeight)
@mapdef Entity "playbackTutorial" PlayerPlayback(x::Integer, y::Integer, tutorial::String="", nodes::Array{Tuple{Integer, Integer}, 1}=Tuple{Integer, Integer}[])

@mapdef Entity "kevins_pc" KevinsPC(x::Integer, y::Integer)
@mapdef Entity "wavedashmachine" WaveDashMachine(x::Integer, y::Integer)
InternetCafe = WaveDashMachine

@mapdef Entity "everest/customBirdTutorial" EverestCustomBird(x::Integer, y::Integer, birdId::String="", onlyOnce::Bool=false, caw::Bool=true, faceLeft::Bool=true, info::String="TUTORIAL_DREAMJUMP", controls::String="DownRight,+,Dash,tinyarrow,Jump")

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

    return res
end