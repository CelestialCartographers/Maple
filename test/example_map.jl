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

println("Map type")
@time map = Map(
    "Testing",
    Level[
        Level(
            name = "lvl_1",

            fgTiles = FgTiles(lvl_1_fg),

            position = (0, 0),
            size = (384, 200),

            entities = Entity[
                Player(16, 144),
                ChapterCheckpoint(16, 144),

                TheoCrystal(80, 80),
                TempleGate(160, 144, 48, "HoldingTheo", "theo"),

                DashSwitchHorizontal(176, 144, false),
                DashSwitchHorizontal(192, 144, true),


                DashSwitchVertical(208, 144, false),
                DashSwitchVertical(224, 144, true),
            ],
        )
    ]
)

println("Dict of map $(map.package)")
@time dMap = Dict(map)

println("Total encode time")
@time encodeMap(dMap, "Testing.bin")