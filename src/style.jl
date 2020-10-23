abstract type Backdrop

end

@valueequals @fieldproxy mutable struct Parallax <: Backdrop
    data::Dict{String, Any}

    Parallax(data::Dict{String, Any}) = new(data)
    Parallax(; kwargs...) = new(Dict(string(a) => b for (a, b) in kwargs))
end

@valueequals @fieldproxy mutable struct Effect{T} <: Backdrop
    name::String
    data::Dict{String, Any}

    Effect{T}(name::String, data::Dict{String, Any}) where T = new{T}(name, data)
    Effect{T}(name::String; kwargs...) where T = new{T}(name, Dict(string(a) => b for (a, b) in kwargs))
end

Effect(name::String, data::Dict{String, Any}) = Effect{Symbol(name)}(name, data)
Effect(name::String; kwargs...) = Effect{Symbol(name)}(name, Dict(string(a) => b for (a, b) in kwargs))

@fieldproxy mutable struct Apply <: Backdrop
    data::Dict{String, Any}
    parallax::Array{Union{Effect, Parallax}, 1}

    Apply(data::Dict{String, Any}, parallax::Array{Union{Effect, Parallax}, 1}) = new(data, parallax)
    Apply(parallax::Array{Union{Effect, Parallax}, 1}; kwargs...) = new(Dict(string(a) => b for (a, b) in kwargs), parallax)
end

@mapdef Effect "snowFg" SnowFg(only::String="*", exclude::String="")
@mapdef Effect "snowBg" SnowBg(only::String="*", exclude::String="")
@mapdef Effect "heatwave" Heatwave(only::String="*", exclude::String="")
@mapdef Effect "dreamstars" DreamStars(only::String="*", exclude::String="")
@mapdef Effect "stars" Stars(only::String="*", exclude::String="")
@mapdef Effect "mirrorfg" MirrorFg(only::String="*", exclude::String="")
@mapdef Effect "reflectionfg" ReflectionFg(only::String="*", exclude::String="")
@mapdef Effect "corestarsfg" CoreStarFg(only::String="*", exclude::String="")
@mapdef Effect "godrays" GodRays(only::String="*", exclude::String="")
@mapdef Effect "bossStarField" BossStarField(only::String="*", exclude::String="")
@mapdef Effect "windsnow" Wind(only::String="*", exclude::String="", color::String="")
@mapdef Effect "planets" Planets(only::String="*", exclude::String="", count::Number=32, size::String="small", color::String="", scrollx::Number=1.0, scrolly::Number=1.0)
@mapdef Effect "starfield" Starfield(only::String="*", exclude::String="", color::String="", scrollx::Number=1.0, scrolly::Number=1.0, speed::Number=1.0)
@mapdef Effect "petals" Petals(only::String="*", exclude::String="")
@mapdef Effect "northernlights" NorthernLights(only::String="*", exclude::String="")
@mapdef Effect "tentacles" TentacleEffect(only::String="*", exclude::String="", side::String="Right", color::String="", offset::Number=0)
@mapdef Effect "stardust" StarDust(only::String="*", exclude::String="")
@mapdef Effect "rain" Rain(only::String="*", exclude::String="", color::String="161933") # Color added by Everest
@mapdef Effect "blackhole" BlackHole(only::String="*", exclude::String="")

mutable struct Style
    foregrounds::Array{Backdrop, 1}
    backgrounds::Array{Backdrop, 1}

    Style(fg::Array{Backdrop, 1}, bg::Array{Backdrop, 1}) = new(fg, bg)
    Style() = new(Backdrop[], Backdrop[])
end

function expandApply(style::Backdrop)
    if isa(style, Maple.Apply)
        res = Backdrop[]

        for p in style.parallax
            if isa(p, Maple.Parallax)
                push!(res, Maple.Parallax(merge(style.data, p.data)))

            elseif isa(p, Maple.Effect)
                push!(res, Maple.Effect(p.name, merge(style.data, p.data)))
            end
        end

        return res

    else
        return Backdrop[style]
    end
end

# Expand Apply types into parallax/effect
# Easier to use for both coding and user perspective
function expandStylegroundApplies(backdrops::Array{Backdrop, 1})
    res = Backdrop[]

    for backdrop in backdrops
        append!(res, expandApply(backdrop))
    end

    return res
end
    
function expandStylegroundApplies!(style::Style)
    style.foregrounds = expandStylegroundApplies(style.foregrounds)
    style.backgrounds = expandStylegroundApplies(style.backgrounds)
end

function Base.Dict(s::Style)
    return Dict{String, Any}[
        Dict{String, Any}(
            "__name" => "Foregrounds",
            "__children" => Dict.(s.foregrounds)
        ),

        Dict{String, Any}(
            "__name" => "Backgrounds",
            "__children" => Dict.(s.backgrounds)
        )
    ]
end

function Base.Dict(p::Parallax)
    res = copy(p.data)

    res["__name"] = "parallax"

    return res
end

function Base.Dict(a::Apply)
    res = copy(a.data)

    res["__name"] = "apply"
    res["__children"] = Dict.(a.parallax)

    return res
end

function Base.Dict(e::Effect)
    res = copy(e.data)

    res["__name"] = e.name

    return res
end