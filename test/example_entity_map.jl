# Temporarily add this repo's Maple to the module path.
# Do not use this if you installed Maple using Pkg.add.
push!(LOAD_PATH, "$(pwd())/src")

using Maple

# See top dictionary in `entity_map.jl` for currently implemented shorthands
lvl_1_fg = """
333333333333333333333333333333333333333333333333
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3333333                                        3
3vvvvvv    Q                         F         3
3                                              3
3        O                                     3
3>                                             3
3>    3333>  R                                 3
3     3333>        DDDDDD                      3
3                  DDDDDD                      3
3P ^^^^^^                                      3
333333333333333333333333333333333333333333333333
"""

fgTiles = FgTiles(lvl_1_fg)
height, width = size(fgTiles.data) .* 8

map = Map(
    "EntityMapExample",
    Level[
        Level(
            name = "lvl_1",

            fgTiles = fgTiles,

            position = (0, 0),
            size = (width, height),

            entities = entityMap(lvl_1_fg)
        )
    ]
)

dMap = Dict(map)
encodeMap(dMap, "Testing-EntityMap.bin")