# Temporarily add this repo's Maple to the module path.
# Do not use this if you installed Maple using Pkg.clone.
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

map = Map(
    "EntityMapExample",
    Room[
        Room(
            name = "lvl_1",

            fgTiles = fgTiles,

            position = (0, 0),
            size = size(fgTiles),

            entities = entityMap(lvl_1_fg)
        )
    ]
)

encodeMap(map, "Testing-EntityMap.bin")