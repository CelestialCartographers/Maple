__precompile__()

module Maple
macro exportalltypes()
    return Expr(:export, filter(val -> match(r"#|@|(^[a-z])", string(val)) === nothing, names(Maple, true))...)
end

include("metadata.jl")
include("map_coder.jl")

@exportalltypes

# export functions manually
export encodeMap, loadMap, entityMap, yaml, getRoomByName

end