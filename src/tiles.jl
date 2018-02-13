VALID_FG_TILES = Char[
    '0', '1', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd', 'e',
    'f', 'g', 'G', 'h', 'i', 'j', 'k',
    'l'
]

VALID_BG_TILES = Char[
    '0', '1', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd'
]

mutable struct Tiles
    data::Array{Char, 2}

    Tiles() = new(fill('0', (40, 23)))

    Tiles(d::Array{Char, 2}) = new(d)

    function Tiles(s::String)
        s = replace(s, "\r\n", "\n")
        lines = split(s, "\n")

        cols = maximum(length.(lines))
        rows = length(lines)

        res = fill('0', rows, cols)

        for (i, line) in enumerate(lines)
            res[i, 1:length(line)] = collect(line)
        end

        return new(res)
    end
end

# Removes illegal characters from the tileset
# Makes it possible to put simple entity map and fg in same string
function FgTiles(s::String, valid::Array{Char, 1}=VALID_FG_TILES)
    tiles = Tiles(s)
    tiles.data = [c in valid? c : '0' for c in tiles.data]

    return tiles
end
function BgTiles(s::String)
    tiles = Tiles(s)
    tiles.data = [c in valid? c : '0' for c in tiles.data]

    return tiles
end

function Base.string(t::Tiles)
    return join(String.([t.data[i, :] for i in 1:size(t.data, 1)]), "\n")
end
