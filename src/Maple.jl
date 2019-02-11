__precompile__()

module Maple

include("macros.jl")
include("metadata.jl")
include("side.jl")
include("map_coder.jl")

@exportalltypes

# export functions manually
export encodeMap, loadMap, encodeSide, loadSide, entityMap, getRoomByName, getSideName
export @pardef, @kwproxy, @mapdef

end