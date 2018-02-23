# Temporarily add this repo's Maple to the module path.
# Do not use this if you installed Maple using Pkg.add.
push!(LOAD_PATH, "$(pwd())/src")

using Maple

# '0' and ' ' will be confidered "nothing"
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
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
3                                              3
333333333333333333333333333333333333333333333333
"""

fgTiles = FgTiles(lvl_1_fg)

println("Map type")
@time map = Map(
    "Testing",
    Level[
        Level(
            name = "lvl_1",

            fgTiles = fgTiles,

            position = (0, 0),
            size = size(fgTiles),

            entities = Entity[
                Player(16, 144),
                ChapterCheckpoint(16, 144),

                CustomMemorial(160, 160, true, "memorial_test", "decals/playerR"),
            ],
        )
    ]
)

println("Dict of map $(map.package)")
@time dMap = Dict(map)

println("Total encode time")
@time encodeMap(dMap, "Testing.bin")