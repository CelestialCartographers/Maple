include("level.jl")

mutable struct Map
    package::String
    levels::Array{Level, 1}
end

function Base.Dict(m::Map)
    return Dict{String, Any}(
        "_package" => m.package,
        "__name" => "Map",
        "__children" => [
            Dict{String, Any}(
                "__name" => "levels",
                "__children" => Dict.(m.levels)
            )
        ]
    )
end