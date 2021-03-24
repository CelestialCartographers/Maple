__precompile__()

module Maple

include("attributetypes.jl")
include("macros.jl")
include("map_coder.jl")
include("metadata.jl")
include("side.jl")

@exportalltypes

# export functions manually
export encodeMap, loadMap, encodeSide, loadSide, entityMap, getRoomByName, getSideName, getPreferredType
export @pardef, @kwproxy, @mapdef, @valueequals

end