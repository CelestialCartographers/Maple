@valueequals mutable struct Decal
    texture::String

    x::Number
    y::Number

    scaleX::Number
    scaleY::Number

    rotation::Number

    Decal(texture::String, x::Number, y::Number, scaleX::Number=1, scaleY::Number=1, rotation::Number=0) = new(texture, x, y, scaleX, scaleY, rotation)
end

function Base.Dict(d::Decal)
    res = Dict{String, Any}(
        "texture" => d.texture,

        "x" => d.x,
        "y" => d.y,

        "scaleX" => d.scaleX,
        "scaleY" => d.scaleY,

        "__name" => "decal",
    )

    if d.rotation != 0
        res["rotation"] = d.rotation
    end

    return res
end