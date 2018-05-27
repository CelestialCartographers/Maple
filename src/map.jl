using Parameters

include("room.jl")
include("style.jl")

# Quirk with the "fancy" JSON converting, make sure we always have an array to work with
packIfDict(data) = isa(data, Dict) ? Dict{String, Any}[data] : data

struct Map
    package::String
    rooms::Array{Room, 1}
    style::Style

    Map(package::String) = new(package, Room[], Style())
    Map(package::String, rooms::Array{Room, 1}) = new(package, rooms, Style())
    Map(package::String, rooms::Room...) = new(package, rooms, Style())
    Map(package::String, rooms::Array{Room, 1}, style::Style) = new(package, rooms, style)
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
            )

            # TODO - Filler rects?
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
        
        if x > roomX && x < roomX + width && y > roomY && y < roomY + height
            return room
        end
    end

    return false
end

encodeMap(map::Map, outfile::String) = encodeMap(Dict(map), outfile)

loadMap(fn::String) = loadMap(decodeMap(fn))

function loadStyleground(styleData::Dict{String, Any})
    style = Styleground()

    for (styleType, data) in styleData
        if styleType == "parallax"
            for p in packIfDict(data)
                push!(style.children, Parallax(p))
            end

        elseif styleType == "apply"
            for a in packIfDict(data)
                parallax = Parallax[]

                if haskey(a, "parallax")
                    for p in packIfDict(a["parallax"])
                        push!(parallax, Parallax(p))
                    end
                end

                push!(style.children, Apply(
                    get(a, "loopx", false),
                    get(a, "loopy", false),

                    get(a, "scrollx", 1),
                    get(a, "scrolly", 1),

                    get(a, "only", ""),
                    get(a, "always", ""),

                    parallax
                ))
            end

        else
            push!(style.children, Effect(styleType, get(data, "only", "*")))
        end
    end

    return style
end

# TODO Consider splitting this up like styleground
function loadMap(map::Dict{String, Any})
    mapData = map["Map"]
    package = map["_package"]
    roomsData = mapData["levels"]["level"]

    rooms = Room[]

    style = get(mapData, "Style", Dict{Any, String}())
    
    fgStyle = loadStyleground(get(style, "Foregrounds", Dict{String, Any}()))
    bgStyle = loadStyleground(get(style, "Backgrounds", Dict{String, Any}()))

    # Add rooms
    for room in packIfDict(roomsData)
        # Add fg decals
        fgDecals = Decal[]
        if haskey(room, "fgdecals")
            for (decalName, decalData) in room["fgdecals"]
                if decalName != "offsetX" && decalName != "offsetY" && decalName != "tileset" && decalName != "exportMode"
                    for data in packIfDict(decalData)
                        push!(fgDecals, Decal(data["texture"], data["x"], data["y"], data["scaleX"], data["scaleY"]))
                    end
                end
            end
        end

        # Add bg decals
        bgDecals = Decal[]
        if haskey(room, "bgdecals")
            for (decalName, decalData) in room["bgdecals"]
                if decalName != "offsetX" && decalName != "offsetY" && decalName != "tileset" && decalName != "exportMode"
                    for data in packIfDict(decalData)
                        push!(bgDecals, Decal(data["texture"], data["x"], data["y"], data["scaleX"], data["scaleY"]))
                    end
                end
            end
        end

        # Add room entities
        entities = Entity[]
        if haskey(room, "entities")
            for (entityName, entityData) in room["entities"]
                # Special cases
                if entityName == "offsetX" || entityName == "offsetY"
                    continue

                #elseif entityName == "ridgeGate"
                    # TBI
                    # Has a weird data structure to point at strawberries
            
                else
                    for data in packIfDict(entityData)
                        id = get(data, "id", -1)
                        delete!(data, "id")

                        if haskey(data, "node")
                            data["nodes"] = Tuple{Integer, Integer}[(node["x"], node["y"]) for node in packIfDict(data["node"])]
                        end

                        delete!(data, "node")

                        push!(entities, Entity(entityName, id, data))
                    end
                end
            end
        end

        # Add room entities
        triggers = Trigger[]
        if haskey(room, "triggers")
            for (triggerName, triggerData) in room["triggers"]
                # Special cases
                if triggerName == "offsetX" || triggerName == "offsetY"
                    continue

                else
                    for data in packIfDict(triggerData)
                        id = get(data, "id", -1)
                        delete!(data, "id")

                        if haskey(data, "node")
                            data["nodes"] = Tuple{Integer, Integer}[(node["x"], node["y"]) for node in packIfDict(data["node"])]
                        end

                        delete!(data, "node")

                        push!(triggers, Trigger(triggerName, id, data))
                    end
                end
            end
        end


        # fgtiles
        fgTiles = Tiles(get(room["solids"], "innerText", ""))

        # bgtiles
        bgTiles = Tiles(get(room["bg"], "innerText", ""))

        push!(rooms, Room(
            name = get(room, "name", "lvl_1"),
            
            position = (room["x"], room["y"]),
            size = (room["width"], room["height"]),

            entities = entities,
            triggers = triggers,

            bgDecals = bgDecals,
            fgDecals = fgDecals,

            fgTiles = fgTiles,
            bgTiles = bgTiles,

            musicLayer1 = get(room, "musicLayer1", true),
            musicLayer2 = get(room, "musicLayer2", true),
            musicLayer3 = get(room, "musicLayer3", true),
            musicLayer4 = get(room, "musicLayer4", true),

            dark = get(room, "dark", false),
            space = get(room, "space", false),
            underwater = get(room, "underwater", false),
            whisper = get(room, "whisper", false),
            disableDownTransition = get(room, "disableDownTransition", false),

            music = get(room, "music", "music_oldsite_awake"),
            alt_music = get(room, "alt_music", ""),
            
            windPattern = get(room, "windPattern", "None")
        ))
    end

    return Map(package, rooms, Style(fgStyle, bgStyle))
end