using Parameters

include("level.jl")
include("style.jl")

packIfDict(data) = isa(data, Dict) ? Dict{String, Any}[data] : data

struct Map
    package::String
    levels::Array{Level, 1}
    style::Style

    Map(package::String, levels::Array{Level, 1}) = new(package, levels, Style())
    Map(package::String, levels::Level...) = new(package, levels, Style())

    Map(package::String, levels::Array{Level, 1}, style::Style) = new(package, levels, style)
end

function Base.Dict(m::Map)
    return Dict{String, Any}(
        "_package" => m.package,
        "__name" => "Map",
        "__children" => [
            # Levels
            Dict{String, Any}(
                "__name" => "levels",
                "__children" => Dict.(m.levels)
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

function loadMap(map::Dict{String, Any})
    mapData = map["Map"]
    package = map["_package"]
    levelsData = mapData["levels"]["level"]

    levels = Level[]

    style = get(mapData, "Style", Dict{Any, String}())
    
    fgStyle = loadStyleground(get(style, "Foregrounds", Dict{String, Any}()))
    bgStyle = loadStyleground(get(style, "Backgrounds", Dict{String, Any}()))

    # Add levels
    for level in packIfDict(levelsData)
        # Add fg decals
        fgDecals = Decal[]
        if haskey(level, "fgdecals")
            for (decalName, decalData) in level["fgdecals"]
                if decalName != "offsetX" && decalName != "offsetY" && decalName != "tileset" && decalName != "exportMode"
                    for data in packIfDict(decalData)
                        push!(fgDecals, Decal(data["texture"], data["x"], data["y"], data["scaleX"], data["scaleY"]))
                    end
                end
            end
        end

        # Add bg decals
        bgDecals = Decal[]
        if haskey(level, "bgdecals")
            for (decalName, decalData) in level["bgdecals"]
                if decalName != "offsetX" && decalName != "offsetY" && decalName != "tileset" && decalName != "exportMode"
                    for data in packIfDict(decalData)
                        push!(bgDecals, Decal(data["texture"], data["x"], data["y"], data["scaleX"], data["scaleY"]))
                    end
                end
            end
        end

        # Add level entities
        entities = Entity[]
        if haskey(level, "entities")
            for (entityName, entityData) in level["entities"]
                # Special cases
                if entityName == "offsetX" || entityName == "offsetY"
                    continue

                elseif entityName == "ridgeBlock"
                    # TBI
            
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

        # Add level entities
        triggers = Trigger[]
        if haskey(level, "triggers")
            for (triggerName, triggerData) in level["triggers"]
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
        fgTiles = FgTiles(get(level["solids"], "innerText", ""))

        # bgtiles
        bgTiles = BgTiles(get(level["bg"], "innerText", ""))

        push!(levels, Level(
            name = get(level, "name", "lvl_1"),
            
            position = (level["x"], level["y"]),
            size = (level["width"], level["height"]),

            entities = entities,
            triggers = triggers,

            bgDecals = bgDecals,
            fgDecals = fgDecals,

            fgTiles = fgTiles,
            bgTiles = bgTiles,

            musicLayer1 = get(level, "musicLayer1", true),
            musicLayer2 = get(level, "musicLayer2", true),
            musicLayer3 = get(level, "musicLayer3", true),
            musicLayer4 = get(level, "musicLayer4", true),

            dark = get(level, "dark", false),
            space = get(level, "space", false),
            underwater = get(level, "underwater", false),
            whisper = get(level, "whisper", false),
            disableDownTransition = get(level, "disableDownTransition", false),

            music = get(level, "music", "music_oldsite_awake"),
            alt_music = get(level, "alt_music", ""),
            
            windPattern = get(level, "windPattern", "None")
        ))
    end

    return Map(package, levels, Style(fgStyle, bgStyle))
end