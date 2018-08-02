mutable struct Filler
    x::Integer
    y::Integer
    w::Integer
    h::Integer
end

function Base.Dict(filler::Filler)
    return Dict{String, Any}(
        "__name" => "rect",

        "x" => filler.x,
        "y" => filler.y,

        "w" => filler.w,
        "h" => filler.h
    )
end