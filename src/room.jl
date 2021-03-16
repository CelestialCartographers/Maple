include("entity.jl")
include("decal.jl")
include("trigger.jl")
include("tiles.jl")
include("object_tiles.jl")
include("nodes.jl")
include("entity_map.jl")
include("enums.jl")

@valueequals Base.@kwdef mutable struct Room
    fgDecals::Array{Decal, 1} = Decal[]
    bgDecals::Array{Decal, 1} = Decal[]

    fgTiles::Tiles = Tiles()
    bgTiles::Tiles = Tiles()
    objTiles::ObjectTiles = ObjectTiles()

    entities::Array{Entity, 1} = Entity[]

    triggers::Array{Trigger, 1} = Trigger[]

    name::String = "lvl_1"
    color::Integer = 0

    position::Tuple{Integer, Integer} = (0, 0)
    size::Tuple{Integer, Integer} = (320, 184)

    musicLayer1::Bool = true
    musicLayer2::Bool = true
    musicLayer3::Bool = true
    musicLayer4::Bool = true

    musicProgress::String = ""
    ambienceProgress::String = ""

    delayAltMusicFade::Bool = false

    dark::Bool = false
    space::Bool = false
    underwater::Bool = false
    whisper::Bool = false

    music::String = "music_oldsite_awake"
    altMusic::String = ""

    disableDownTransition::Bool = false

    windPattern::String = "None"

    cameraOffsetX::Number = 0.0
    cameraOffsetY::Number = 0.0
end

function tileDataCopy!(to::Matrix, from::Matrix, width::Int, height::Int)
    indices = CartesianIndices((1:height, 1:width))

    copyto!(to, indices, from, indices)
end

function getCopySize(data::Matrix, width::Int, height::Int)
    h, w = size(data)

    return min(h, height), min(w, width)
end

# Set the fg and bg tiles to the size of the room
function updateTileSize!(room::Room, center::Char='0', border::Char='0')
    tw, th = ceil.(Int, room.size ./ 8)

    fgTiles = fill(center, (th, tw))
    bgTiles = fill(center, (th, tw))
    objTiles = fill(-1, (th, tw))

    fth, ftw = getCopySize(room.fgTiles.data, tw, th)
    bth, btw = getCopySize(room.bgTiles.data, tw, th)
    oth, otw = getCopySize(room.objTiles.data, tw, th)

    tileDataCopy!(fgTiles, room.fgTiles.data, ftw, fth)
    tileDataCopy!(bgTiles, room.bgTiles.data, btw, bth)
    tileDataCopy!(objTiles, room.objTiles.data, otw, oth)

    room.fgTiles = Tiles(fgTiles)
    room.bgTiles = Tiles(bgTiles)
    room.objTiles = ObjectTiles(objTiles)
end

const blacklistedRoomAttrs = String["position", "size", "color", "fgDecals", "bgDecals", "fgTiles", "bgTiles", "objTiles", "entities", "triggers"]

function Base.Dict(r::Room)
    res = Dict{String, Any}()

    for f in fieldnames(typeof(r))
        fs = String(f)
        value = getfield(r, f)

        if !(fs in blacklistedRoomAttrs)
            res[fs] = value
        end
    end

    res["__name"] = "level"

    res["x"] = r.position[1]
    res["y"] = r.position[2]

    res["c"] = r.color

    res["width"] = r.size[1]
    res["height"] = r.size[2]

    res["__children"] = Dict{String, Any}[
        Dict{String, Any}(
            "__name" => "solids",
            "innerText" => minimizeTilesString(r.fgTiles.data, '0', "")
        ),

        Dict{String, Any}(
            "__name" => "bg",
            "innerText" => minimizeTilesString(r.bgTiles.data, '0', ""),
        ),

        Dict{String, Any}(
            "__name" => "objtiles",
            "innerText" => minimizeTilesString(r.objTiles.data, -1, ','),
        ),

        Dict{String, Any}(
            "__name" => "fgtiles",
            "tileset" => "Scenery",
        ),

        Dict{String, Any}(
            "__name" => "bgtiles",
            "tileset" => "Scenery",
        ),

        Dict{String, Any}(
            "__name" => "entities",
            "__children" => Dict.(r.entities)
        ),

        Dict{String, Any}(
            "__name" => "triggers",
            "__children" => Dict.(r.triggers)
        ),

        Dict{String, Any}(
            "__name" => "fgdecals",
            "tileset" => "Scenery",
            "__children" => Dict.(r.fgDecals)
        ),

        Dict{String, Any}(
            "__name" => "bgdecals",
            "tileset" => "Scenery",
            "__children" => Dict.(r.bgDecals)
        )
    ]

    return res
end