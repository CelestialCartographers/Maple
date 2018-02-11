mutable struct Decal
    texture::String

    x::Integer
    y::Integer

    scaleX::Integer
    scaleY::Integer
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