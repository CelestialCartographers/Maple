mutable struct Parallax
    data::Dict{String, Any}

    Parallax(data::Dict{String, Any}) = new(data)
    Parallax(; kwargs...) = new(Dict(string(a) => b for (a, b) in kwargs))
end

mutable struct Apply
    loopX::Bool
    loopY::Bool

    scrollX::Integer
    scrollY::Integer

    only::Array{String, 1}
    always::Array{String, 1}

    parallax::Array{Parallax, 1}

    Apply(lx::Bool, ly::Bool, sx::Integer, sy::Integer, only::Array{String, 1}, always::Array{String, 1}, parallax::Array{Parallax, 1}) = new(lx, ly, sx, sy, only, always, parallax)
    Apply(lx::Bool, ly::Bool, sx::Integer, sy::Integer, only::String, always::String, parallax::Array{Parallax, 1}) = new(lx, ly, sx, sy, split(only, ","), split(always, ","), parallax)
end

mutable struct Effect
    typ::String

    only::Array{String, 1}

    Effect(typ::String, only::Array{String, 1}) = new(typ, only)
    Effect(typ::String, only::String) = new(typ, split(only, ","))
    Effect(typ::String) = new(typ, String[])
end

SnowFg(only::Array{String, 1}=String["*"]) = Effect("snowFg", only)
SnowBg(only::Array{String, 1}=String["*"]) = Effect("snowBg", only)
Heatwave(only::Array{String, 1}=String["*"]) = Effect("heatwave", only)
Stars(only::Array{String, 1}=String["*"]) = Effect("corestarsfg", only)
Wind(only::Array{String, 1}=String["*"]) = Effect("windsnow", only)

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
    res = Dict{String, Any}()

    res["__name"] = "apply"
    res["__children"] = Dict.(a.parallax)

    res["loopx"] = a.loopX
    res["loopy"] = a.loopY

    res["scrollx"] = a.scrollX
    res["scrolly"] = a.scrollY

    if length(a.only) > 0 && a.only[1] != ""
        res["only"] = join(a.only, ",")
    end

    if length(a.always) > 0 && a.always[1] != ""
        res["always"] = join(a.always, ",")
    end

    return res
end

function Base.Dict(e::Effect)
    res = Dict{String, Any}()

    res["__name"] = e.typ
    res["only"] = join(e.only, ",")

    return res
end