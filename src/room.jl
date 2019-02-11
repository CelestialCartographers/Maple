include("entity.jl")
include("decal.jl")
include("trigger.jl")
include("tiles.jl")
include("object_tiles.jl")
include("nodes.jl")
include("entity_map.jl")
include("enums.jl")

Base.@kwdef mutable struct Room
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

    dark::Bool = false
    space::Bool = false
    underwater::Bool = false
    whisper::Bool = false

    music::String = "music_oldsite_awake"
    alt_music::String = ""

    disableDownTransition::Bool = false

    windPattern::String = "None"
end

# Set the fg and bg tiles to the size of the room
function updateTileSize!(room::Room, center::Char='0', border::Char='0')
    tw, th = ceil.(Int, room.size ./ 8)

    tiles = fill(center, (th, tw))
    objTiles = fill(-1, (th, tw))

    fth, ftw = min.(size(room.fgTiles.data), (th, tw))
    bth, btw = min.(size(room.bgTiles.data), (th, tw))
    oth, otw = min.(size(room.objTiles.data), (th, tw))

    fg = copy(tiles)
    bg = copy(tiles)

    fg[1:fth, 1:ftw] = room.fgTiles.data[1:fth, 1:ftw]
    bg[1:bth, 1:btw] = room.bgTiles.data[1:bth, 1:btw]
    objTiles[1:oth, 1:otw] = room.objTiles.data[1:oth, 1:otw]

    room.fgTiles = Tiles(fg)
    room.bgTiles = Tiles(bg)
    room.objTiles = ObjectTiles(objTiles)
end

blacklistedRoomAttrs = String["position", "size", "color", "fgDecals", "bgDecals", "fgTiles", "bgTiles", "objTiles", "entities", "triggers"]

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