# Temporarily add this repo's Maple to the module path.
# Do not use this if you installed Maple using Pkg.add.
push!(LOAD_PATH, "$(pwd())/src")

using Maple

lvl_1_fg = """
333333333333333333333333333333333333333333333333
3                                              3
3                                              3
3                                              3
3                                              3
333333333                                      3
3                                              3
3                                              3
3            33   33                           3
3            3     3                           3
3            3     3                           3
3            3     3                           3
3            3     3                333333333333
3            3     3            R              3
3            3333333                           3
3                                              3
3                R                             3
3                               3333333333     3
3                               3              3
3          3333                 3              3
3             3                 3              3
3             3                 3              3
3P            3                 3              3
333333333333333333333333333333333333333333333333
"""

fgTiles = FgTiles(lvl_1_fg)
height, width = size(fgTiles.data) .* 8

println("Map type")
@time map = Map(
    "Cruor-Testing",
    Level[
        Level(
            name = "lvl_3",

            fgTiles = fgTiles,

            position = (0, 0),
            size = (width, height),

            space = true,

            entities = vcat(
                Entity[

                    MoveBlock(32, 80, 32, 32, "Right", true),
                    MoveBlock(96, 80, 32, 32, "Up", true),
                ],
                entityMap(lvl_1_fg)
            )
        )
    ],

    # Forsaken City Style
    # This is just to show how Styles currently work, if you want to mimic styles of existing chapters
    # You probably want `loadMap("Maps/1-ForsakenCity.bin").style` instead
    # (Maple does not include these)
    Style(
        Styleground([
            SnowFg()
        ]),
    
        Styleground([
            Parallax(
                loopx = true,
                scrolly = 0.03,
                loopy = false,
                x = -100,
                scrollx = 0.03,
                texture = "bgs/01/bg0",
                y = 0
            ),
            Parallax(
                loopx = true,
                scrolly = 0.04,
                loopy = false,
                x = 0,
                scrollx = 0.08,
                texture = "bgs/01/bg1",
                y = -30
            ),
            Parallax(
                loopx = true,
                scrolly = 0.1,
                loopy = false,
                x = 0,
                scrollx = 0.1,
                texture = "bgs/01/bg2",
                y = -50
            ),
            Parallax(
                loopx = true,
                scrolly = 0.12,
                loopy = false,
                x = 0,
                scrollx = 0.12,
                texture = "bgs/00/bg2",
                y = 0
            ),
            Parallax(
                loopx = true,
                scrolly = 0.15,
                loopy = false,
                x = 0,
                scrollx = 0.15,
                texture = "bgs/00/bg3",
                y = 0
            ),
        ])
    )
)

println("Total encode time")
@time encodeMap(map, "../ModContent/Maps/$(map.package).bin")
