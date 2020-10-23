@valueequals mutable struct Decal
    texture::String

    x::Number
    y::Number

    scaleX::Integer
    scaleY::Integer

    Decal(texture::String, x::Number, y::Number, scaleX::Integer=1, scaleY::Integer=1) = new(texture, x, y, scaleX, scaleY)
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