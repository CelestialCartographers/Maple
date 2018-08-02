using Parameters

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

Base.isequal(lhs::Map, rhs::Map) = Dict(lhs) == Dict(rhs)

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
                applyAttr = attributes(a)

                parallax = Union{Parallax, Effect}[]
                for (typ, d) in children(a)
                    if typ == "parallax"
                        push!(parallax, Parallax(d))

                    else
                        push!(parallax, Effect(typ, d))
                    end
                end

                push!(style.children, Apply(applyAttr, parallax))
            end

        else
            for e in packIfDict(data)
                push!(style.children, Effect(styleType, e))
            end
        end
    end

    return style
end

function loadFillerRects(fillerData::Dict{String, Any})
    res = Filler[]

    for (typ, data) in fillerData
        if typ == "rect"
            for r in packIfDict(data)
                push!(res, Filler(r["x"], r["y"], r["w"], r["h"]))
            end
        end
    end

    return res
end

# TODO Consider splitting this up like styleground
function loadMap(map::Dict{String, Any})
    mapData = map["Map"]
    package = map["_package"]
    roomsData = get(mapData["levels"], "level", Dict{String, Any}[])

    rooms = Room[]

    style = get(mapData, "Style", Dict{String, Any}())
    
    fgStyle = loadStyleground(get(style, "Foregrounds", Dict{String, Any}()))
    bgStyle = loadStyleground(get(style, "Backgrounds", Dict{String, Any}()))

    fillerRects = loadFillerRects(get(mapData, "Filler", Dict{String, Any}()))

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

    return Map(package, rooms, Style(fgStyle, bgStyle), fillerRects)
end