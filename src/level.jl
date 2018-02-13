include("entity.jl")
include("entity_map.jl")
include("decal.jl")
include("trigger.jl")
include("tiles.jl")
include("nodes.jl")

@with_kw mutable struct Level
    fgDecals::Array{Decal, 1} = Decal[]
    bgDecals::Array{Decal, 1} = Decal[]

    fgTiles::Tiles = Tiles()
    bgTiles::Tiles = Tiles()

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

    dark::Bool = false
    space::Bool = false
    underwater::Bool = false
    whisper::Bool = false

    music::String = "music_oldsite_awake"
    alt_music::String = ""

    disableDownTransition::Bool = false

    windPattern::String = "None"
end

blacklistedLevelAttrs = String["position", "size", "color", "fgDecals", "bgDecals", "fgTiles", "bgTiles", "entities", "triggers"]

function Base.Dict(l::Level)
    res = Dict{String, Any}()

    for f in fieldnames(l)
        fs = String(f)
        value = getfield(l, f)

        if !(fs in blacklistedLevelAttrs)
            res[fs] = value
        end
    end

    res["__name"] = "level"

    res["x"] = l.position[1]
    res["y"] = l.position[2]

    res["c"] = l.color

    res["width"] = l.size[1]
    res["height"] = l.size[2]

    res["__children"] = Dict{String, Any}[
        Dict{String, Any}(
            "__name" => "solids",
            "innerText" => string(l.fgTiles)
        ),

        Dict{String, Any}(
            "__name" => "bg",
            "innerText" => string(l.bgTiles),
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
            "__children" => Dict.(l.entities)
        ),

        Dict{String, Any}(
            "__name" => "triggers",
            "__children" => Dict.(l.triggers)
        ),


        Dict{String, Any}(
            "__name" => "fgdecals",
            "tileset" => "Scenery",
            "__children" => Dict.(l.fgDecals)
        ),

        Dict{String, Any}(
            "__name" => "bgdecals",
            "tileset" => "Scenery",
            "__children" => Dict.(l.bgDecals)
        )
    ]

    return res
end