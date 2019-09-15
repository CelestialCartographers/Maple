include("room.jl")
include("style.jl")
include("filler.jl")

# Quirk with the "fancy" JSON converting, make sure we always have an array to work with
packIfDict(data) = isa(data, Dict) ? Dict{String, Any}[data] : data

mutable struct Map
    package::String
    rooms::Array{Room, 1}
    style::Style
    fillers::Array{Filler, 1}

    Map(package::String) = new(package, Room[], Style(), Filler[])
    Map(package::String, rooms::Array{Room, 1}) = new(package, rooms, Style(), Filler[])
    Map(package::String, rooms::Room...) = new(package, rooms, Style(), Filler[])
    Map(package::String, rooms::Array{Room, 1}, style::Style, filler::Array{Filler, 1}=Filler[]) = new(package, rooms, style, filler)
end

Base.:(==)(lhs::Map, rhs::Map) = Dict(lhs) == Dict(rhs)

function Base.Dict(m::Map)
    return Dict{String, Any}(
        "_package" => m.package,
        "__name" => "Map",
        "__children" => [
            # Rooms
            Dict{String, Any}(
                "__name" => "levels",
                "__children" => Dict.(m.rooms)
            ),

            # Style
            Dict{String, Any}(
                "__name" => "Style",
                "__children" => Dict(m.style)
            ),

            # Filler rects
            Dict{String, Any}(
                "__name" => "Filler",
                "__children" => Dict.(m.fillers)
            )
        ]
    )
end

function getRoomByName(map::Map, name::String) 
    for room in map.rooms
        if room.name == name
            return room
        end
    end

    return false
end

function getRoomByCoords(map::Map, x::Number, y::Number) 
    for room in map.rooms
        roomX, roomY = Int.(room.position)
        width, height = Int.(room.size)
        
        if x >= roomX && x < roomX + width && y >= roomY && y < roomY + height
            return room
        end
    end

    return false
end

function bounds(m::Maple.Map)
    tlx = tly = typemax(Int)
    brx = bry = typemin(Int)

    for room in m.rooms
        x, y = Int.(room.position)
        w, h = Int.(room.size)

        tlx = min(tlx, x)
        tly = min(tly, y)

        brx = max(brx, x + w)
        bry = max(bry, y + h)
    end

    return tlx, tly, brx, bry
end

encodeMap(map::Map, outfile::String) = encodeMap(Dict(map), outfile)

loadMap(fn::String) = loadMap(decodeMap(fn))

function loadBackdrops(styleData::Dict{String, Any})
    backdrops = Backdrop[]

    for (styleType, data) in styleData
        if styleType == "parallax"
            for p in packIfDict(data)
                push!(backdrops, Parallax(p))
            end

        elseif styleType == "apply"
            for a in packIfDict(data)
                applyAttr = attributes(a)

                parallax = Union{Parallax, Effect}[]
                for (typ, d) in children(a)
                    if typ == "parallax"
                        push!(parallax, Parallax(d))

                    else
                        push!(parallax, Effect(typ, d))
                    end
                end

                push!(backdrops, Apply(applyAttr, parallax))
            end

        else
            for e in packIfDict(data)
                push!(backdrops, Effect(styleType, e))
            end
        end
    end

    return backdrops
end

function loadEntities(roomData::Dict{String, Any}, constructor::Union{Type{Entity}, Type{Trigger}})
    key = constructor == Entity ? "entities" : "triggers"
    entities = constructor[]

    for (entityName, entityData) in get(roomData, key, [])
        # Special cases
        if entityName == "offsetX" || entityName == "offsetY"
            continue
    
        else
            for data in packIfDict(entityData)
                id = get(data, "id", -1)
                id = isa(id, Integer) ? id : 0
                delete!(data, "id")

                if haskey(data, "node")
                    data["nodes"] = Tuple{Integer, Integer}[(node["x"], node["y"]) for node in packIfDict(data["node"])]
                end

                delete!(data, "node")

                push!(entities, constructor(entityName, data, id))
            end
        end
    end

    return entities
end

function loadDecals(roomData::Dict{String, Any}, fg::Bool=true)
    decals = Decal[]
    key = fg ? "fgdecals" : "bgdecals"

    for (decalName, decalData) in get(roomData, key, [])
        if decalName != "offsetX" && decalName != "offsetY" && decalName != "tileset" && decalName != "exportMode"
            for data in packIfDict(decalData)
                push!(decals, Decal(data["texture"], data["x"], data["y"], data["scaleX"], data["scaleY"]))
            end
        end
    end

    return decals
end

function loadRoom(roomData::Dict{String, Any})
    fgDecals = loadDecals(roomData, true)
    bgDecals = loadDecals(roomData, false)

    entities = loadEntities(roomData, Entity)
    triggers = loadEntities(roomData, Trigger)

    fgTilesRaw = get(roomData["solids"], "innerText", "")
    bgTilesRaw = get(roomData["bg"], "innerText", "")
    objTilesRaw = get(get(Dict{String, Any}, roomData, "objtiles"), "innerText", "")

    fgTiles = Tiles(fgTilesRaw)
    bgTiles = Tiles(bgTilesRaw)
    objTiles = ObjectTiles(objTilesRaw)

    room = Room(
        name = get(roomData, "name", "lvl_1"),
        
        position = (roomData["x"], roomData["y"]),
        size = (roomData["width"], roomData["height"]),

        entities = entities,
        triggers = triggers,

        bgDecals = bgDecals,
        fgDecals = fgDecals,

        fgTiles = fgTiles,
        bgTiles = bgTiles,
        objTiles = objTiles,

        musicLayer1 = get(roomData, "musicLayer1", true),
        musicLayer2 = get(roomData, "musicLayer2", true),
        musicLayer3 = get(roomData, "musicLayer3", true),
        musicLayer4 = get(roomData, "musicLayer4", true),

        musicProgress = string(get(roomData, "musicProgress", "")),

        dark = get(roomData, "dark", false),
        space = get(roomData, "space", false),
        underwater = get(roomData, "underwater", false),
        whisper = get(roomData, "whisper", false),
        disableDownTransition = get(roomData, "disableDownTransition", false),

        music = get(roomData, "music", "music_oldsite_awake"),
        alt_music = get(roomData, "alt_music", ""),
        
        windPattern = get(roomData, "windPattern", "None"),

        color = get(roomData, "c", 0)
    )

    updateTileSize!(room, '0', '0')

    return room
end

function loadFillerRects(fillerData::Dict{String, Any})
    fillers = Filler[]

    for (type, data) in fillerData
        if type == "rect"
            for r in packIfDict(data)
                push!(fillers, Filler(r["x"], r["y"], r["w"], r["h"]))
            end
        end
    end

    return fillers
end


function loadMap(map::Dict{String, Any})
    mapData = map["Map"]
    package = map["_package"]
    roomsData = get(Array{Dict{String, Any}, 1}, mapData["levels"], "level")

    style = get(Dict{String, Any}, mapData, "Style")
    
    fgStyle = loadBackdrops(get(Dict{String, Any}, style, "Foregrounds"))
    bgStyle = loadBackdrops(get(Dict{String, Any}, style, "Backgrounds"))

    fillerRects = loadFillerRects(get(Dict{String, Any}, mapData, "Filler"))

    rooms = loadRoom.(packIfDict(roomsData))

    return Map(package, rooms, Style(fgStyle, bgStyle), fillerRects)
end