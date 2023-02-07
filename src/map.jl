include("room.jl")
include("style.jl")
include("filler.jl")

@valueequals mutable struct Map
    package::String
    rooms::Array{Room, 1}
    style::Style
    fillers::Array{Filler, 1}

    Map(package::String) = new(package, Room[], Style(), Filler[])
    Map(package::String, rooms::Array{Room, 1}) = new(package, rooms, Style(), Filler[])
    Map(package::String, rooms::Room...) = new(package, rooms, Style(), Filler[])
    Map(package::String, rooms::Array{Room, 1}, style::Style, filler::Array{Filler, 1}=Filler[]) = new(package, rooms, style, filler)
end

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

function loadBackdrops(styleData::DecodedElement)
    backdrops = Backdrop[]

    for child in children(styleData)
        styleType = child.name

        if styleType == "parallax"
            push!(backdrops, Parallax(attributes(child)))

        elseif styleType == "apply"
            applyAttr = attributes(child)
            parallax = Union{Parallax, Effect}[]

            for data in children(child)
                type = data.name
                if type == "parallax"
                    push!(parallax, Parallax(attributes(data)))

                else
                    push!(parallax, Effect(type, attributes(data)))
                end
            end

            push!(backdrops, Apply(applyAttr, parallax))

        else
            push!(backdrops, Effect(styleType, attributes(child)))
        end
    end

    return backdrops
end

function loadEntities(roomData::DecodedElement, constructor::Union{Type{Entity}, Type{Trigger}})
    key = constructor == Entity ? "entities" : "triggers"
    entities = constructor[]

    for child in children(findChildWithName(DecodedElement, roomData, key))
        attributes = child.attributes
        id = get(attributes, "id", -1)
        id = isa(id, Integer) ? id : 0
        delete!(attributes, "id")

        nodesRaw = children(child)

        if !isempty(nodesRaw)
            attributes["nodes"] = Tuple{Integer, Integer}[(Int(node.attributes["x"]), Int(node.attributes["y"])) for node in nodesRaw]
        end

        push!(entities, constructor(child.name, attributes, id))
    end

    return entities
end

function loadDecals(roomData::DecodedElement, fg::Bool=true)
    decals = Decal[]
    key = fg ? "fgdecals" : "bgdecals"

    for child in children(findChildWithName(DecodedElement, roomData, key))
        attributes = child.attributes
        rotation = get(attributes, "rotation", 0)

        push!(decals, Decal(attributes["texture"], attributes["x"], attributes["y"], attributes["scaleX"], attributes["scaleY"], rotation))
    end

    return decals
end

function loadRoom(roomData::DecodedElement)
    fgDecals = loadDecals(roomData, true)
    bgDecals = loadDecals(roomData, false)

    entities = loadEntities(roomData, Entity)
    triggers = loadEntities(roomData, Trigger)

    fgTilesRaw = get(findChildWithName(DecodedElement, roomData, "solids"), "innerText", "")
    bgTilesRaw = get(findChildWithName(DecodedElement, roomData, "bg"), "innerText", "")
    objTilesRaw = get(findChildWithName(DecodedElement, roomData, "objtiles"), "innerText", "")

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
        ambienceProgress = string(get(roomData, "ambienceProgress", "")),

        dark = get(roomData, "dark", false),
        space = get(roomData, "space", false),
        underwater = get(roomData, "underwater", false),
        whisper = get(roomData, "whisper", false),
        disableDownTransition = get(roomData, "disableDownTransition", false),

        delayAltMusicFade = get(roomData, "delayAltMusicFade", false),

        music = get(roomData, "music", "music_oldsite_awake"),
        altMusic = get(roomData, "alt_music", ""),

        windPattern = get(roomData, "windPattern", "None"),

        color = get(roomData, "c", 0),

        cameraOffsetX = get(roomData, "cameraOffsetX", 0),
        cameraOffsetY = get(roomData, "cameraOffsetY", 0)
    )

    updateTileSize!(room, '0', '0')

    return room
end

function loadFillerRects(fillerData::DecodedElement)
    fillers = Filler[]

    for child in children(fillerData)
        attributes = child.attributes

        push!(fillers, Filler(attributes["x"], attributes["y"], attributes["w"], attributes["h"]))
    end

    return fillers
end


function loadMap(map::DecodedElement)
    package = map.attributes["package"]

    roomsData = findChildWithName(DecodedElement, map, "levels")
    style = findChildWithName(DecodedElement, map, "Style")

    fgStyle = loadBackdrops(findChildWithName(DecodedElement, style, "Foregrounds"))
    bgStyle = loadBackdrops(findChildWithName(DecodedElement, style, "Backgrounds"))

    fillerRects = loadFillerRects(findChildWithName(DecodedElement, map, "Filler"))

    rooms = loadRoom.(children(roomsData))

    return Map(package, rooms, Style(fgStyle, bgStyle), fillerRects)
end