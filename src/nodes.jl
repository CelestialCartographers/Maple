mutable struct Nodes
    nodes::Array{Tuple{Integer, Integer}, 1}

    function Nodes(s::String)
        tiles = Tiles(s).data
        height, width = size(tiles)

        nodesRaw = Tuple{Char, Tuple{Integer, Integer}}[
            (tiles[y, x], (x * 8 - 4,  y * 8 - 4)) for y in 1:height, x in 1:width if tiles[y, x] != '0' && tiles[y, x] != ' '
        ]
        sort!(nodesRaw, by=(v -> v[1]))

        return new([node[2] for node in nodesRaw])
    end
end