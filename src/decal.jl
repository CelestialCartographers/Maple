mutable struct Decal
    texture::String

    x::Number
    y::Number

    scaleX::Integer
    scaleY::Integer

    Decal(texture::String, x::Number, y::Number, scaleX::Integer=1, scaleY::Integer=1) = new(texture, x, y, scaleX, scaleY)
end

Base.:(==)(lhs::Decal, rhs::Decal) = lhs.texture == rhs.texture && lhs.x == rhs.x && lhs.y == rhs.y && lhs.scaleX == rhs.scaleX && lhs.scaleY == rhs.scaleY

function Base.Dict(d::Decal)
    return Dict{String, Any}(
        "texture" => d.texture,

        "x" => d.x,
        "y" => d.y,

        "scaleX" => d.scaleX,
        "scaleY" => d.scaleY,

        "__name" => "decal",
    )
end