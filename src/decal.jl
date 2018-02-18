mutable struct Decal
    texture::String

    x::Number
    y::Number

    scaleX::Integer
    scaleY::Integer
end

function Decal(texture::String, x::Number, y::Number)
    return Decal(texture, x, y, 1, 1)
end

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