mutable struct Parallax
    data::Dict{String, Any}

    Parallax(data::Dict{String, Any}) = new(data)
    Parallax(; kwargs...) = new(Dict(string(a) => b for (a, b) in kwargs))
end

mutable struct Apply
    data::Dict{String, Any}
    parallax::Array{Parallax, 1}

    Apply(data::Dict{String, Any}, parallax::Array{Parallax, 1}) = new(data, parallax)
    Apply(parallax::Array{Parallax, 1}; kwargs...) = new(Dict(string(a) => b for (a, b) in kwargs), parallax)
end

mutable struct Effect
    typ::String
    data::Dict{String, Any}

    Effect(typ::String, data::Dict{String, Any}) = new(typ, data)
    Effect(typ::String; kwargs...) = new(typ, Dict(string(a) => b for (a, b) in kwargs))
end

SnowFg(data::Dict{String, Any}) = Effect("snowFg", data)
SnowBg(data::Dict{String, Any}) = Effect("snowBg", data)
Heatwave(data::Dict{String, Any}) = Effect("heatwave", data)
Stars(data::Dict{String, Any}) = Effect("corestarsfg", data)
Wind(data::Dict{String, Any}) = Effect("windsnow", data)

Base.isequal(lhs::Parallax, rhs::Parallax) = lhs.data == rhs.data
Base.isequal(lhs::Effect, rhs::Effect) = lhs.typ == rhs.typ && lhs.data == rhs.data

# Maybe care about types?
# TODO Consider removing at some point
struct Styleground
    children::Array

    Styleground(children::Array) = new(children)
    Styleground(children::Any...) = new(children)
    Styleground() = new([])
end

struct Style
    foregrounds::Styleground
    backgrounds::Styleground

    Style(fg::Styleground, bg::Styleground) = new(fg, bg)
    Style() = new(Styleground(), Styleground())
end

function Base.Dict(s::Styleground)
    return Dict{String, Any}[Dict(e) for e in s.children]
end

function Base.Dict(s::Style)
    return Dict{String, Any}[
        Dict{String, Any}(
            "__name" => "Foregrounds",
            "__children" => Dict(s.foregrounds)
        ),

        Dict{String, Any}(
            "__name" => "Backgrounds",
            "__children" => Dict(s.backgrounds)
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

    res["__name"] = e.typ

    return res
end