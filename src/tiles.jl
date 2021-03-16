const tile_fg_names = Dict{Any, Any}(
    '0' => "Air",
    '1' => "Dirt",
    '3' => "Snow",
    '4' => "Girder",
    '5' => "Tower",
    '6' => "Stone",
    '7' => "Cement",
    '8' => "Rock",
    '9' => "Wood",
    'a' => "Wood Stone",
    'b' => "Cliffside",
    'c' => "Pool Edges",
    'd' => "Temple A",
    'e' => "Temple B",
    'f' => "Cliffside Alt",
    'g' => "Reflection",
    'G' => "Reflection Alt",
    'h' => "Grass",
    'i' => "Summit",
    'j' => "Summit No Snow",
    'k' => "Core",
    'l' => "Deadgrass",
    'm' => "Lost Levels",
    'n' => "Scifi",
    'z' => "Template",

    "Air" => '0',
    "Dirt" => '1',
    "Snow" => '3',
    "Girder" => '4',
    "Tower" => '5',
    "Stone" => '6',
    "Cement" => '7',
    "Rock" => '8',
    "Wood" => '9',
    "Wood Stone" => 'a',
    "Cliffside" => 'b',
    "Pool Edges" => 'c',
    "Temple A" => 'd',
    "Temple B" => 'e',
    "Cliffside Alt" => 'f',
    "Reflection" => 'g',
    "Reflection Alt" => 'G',
    "Grass" => 'h',
    "Summit" => 'i',
    "Summit No Snow" => 'j',
    "Core" => 'k',
    "Deadgrass" => 'l',
    "Lost Levels" => 'm',
    "Scifi" => 'n',
    "Template" => 'z'    
)

const tile_bg_names = Dict{Any, Any}(
    '0' => "Air",
    '1' => "Dirt",
    '2' => "Brick",
    '3' => "Brick Ruined",
    '4' => "Wood",
    '5' => "Resort Stone",
    '6' => "Cliffside",
    '7' => "Pool",
    '8' => "Temple A",
    '9' => "Temple B",
    'a' => "Reflection",
    'b' => "Snow",
    'c' => "Summit",
    'd' => "Core",
    'e' => "Lost Levels",
    'z' => "Template",

    "Air" => '0',
    "Dirt" => '1',
    "Brick" => '2',
    "Brick Ruined" => '3',
    "Wood" => '4',
    "Resort Stone" => '5',
    "Cliffside" => '6',
    "Pool" => '7',
    "Temple A" => '8',
    "Temple B" => '9',
    "Reflection" => 'a',
    "Snow" => 'b',
    "Summit" => 'c',
    "Core" => 'd',
    "Lost Levels" => 'e',
    "Template" => 'z'
)

const valid_fg_tiles = Char[
    '0', '1', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd', 'e',
    'f', 'g', 'G', 'h', 'i', 'j', 'k',
    'l'
]

const valid_bg_tiles = Char[
    '0', '1', '2', '3', '4', '5', '6',
    '7', '8', '9', 'a', 'b', 'c', 'd'
]

@valueequals mutable struct Tiles
    data::Array{Char, 2}

    Tiles() = new(fill('0', (40, 23)))

    Tiles(d::Array{Char, 2}) = new(d)

    function Tiles(s::String)
        s = chomp(replace(s, "\r\n" => "\n"))
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
function FgTiles(tiles::Tiles, valid::Array{Char, 1}=valid_fg_tiles)
    tiles.data = [c in valid ? c : '0' for c in tiles.data]

    return tiles
end

FgTiles(tiles::Array{Char, 2}, valid::Array{Char, 1}=valid_fg_tiles) = FgTiles(Tiles(tiles), valid)
FgTiles(s::String, valid::Array{Char, 1}=valid_fg_tiles) = FgTiles(Tiles(s), valid)

BgTiles(tiles::Tiles, valid::Array{Char, 1}=valid_bg_tiles) = FgTiles(tiles, valid)
BgTiles(tiles::Array{Char, 2}, valid::Array{Char, 1}=valid_bg_tiles) = FgTiles(Tiles(tiles), valid)
BgTiles(s::String, valid::Array{Char, 1}=valid_bg_tiles) = FgTiles(Tiles(s), valid)

function getRelevantColumnCount(data::Matrix{T}, emptyValue::T) where T
    rows, cols = size(data)
    columns = fill(0, rows)

    for y in 1:rows
        columns[y] = something(findlast(n -> n != emptyValue, view(data, y, 1:cols)), 0)
    end

    return columns
end

function getRelevantRowCount(columnLengths::Array{Int, 1})
    return something(findlast(n -> n > 0, columnLengths), 0)
end

# All trailing '0's don't need to be written to be loadable
# We can also stop when all remaining rows are '0's
function minimizeTilesString(data::Matrix{T}, emptyValue::T, separator::Union{Char, String}=',') where T
    columnLengths = getRelevantColumnCount(data, emptyValue)
    relevantRows = getRelevantRowCount(columnLengths)

    lines = Array{String, 1}(undef, relevantRows)

    for row in 1:relevantRows
        # String on Char[] is faster than joining with empty string
        if separator == ""
            lines[row] = String(view(data, row, 1:columnLengths[row]))

        else
            lines[row] = join(view(data, row, 1:columnLengths[row]), separator)
        end
    end

    return join(lines, '\n')
end

function Base.string(t::Tiles)
    return join(String.([t.data[i, :] for i in 1:size(t.data, 1)]), "\n")
end

Base.size(t::Tiles) = reverse(size(t.data)) .* 8