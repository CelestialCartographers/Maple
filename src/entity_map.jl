# TODO - Add more
default_entity_map = Dict{Char, Union{Type, Function}}(
    '^' => SpikesUp,
    '<' => SpikesLeft,
    'v' => SpikesDown,
    '>' => SpikesRight,

    'P' => Player,

    'D' => DreamBlock,
    'C' => CrumbleBlock,

    '_' => JumpThru,

    'O' => GreenBooster,
    'Q' => RedBooster,

    'W' => Water,

    'S' => Spinner,

    'B' => Bumper,

    'R' => Refill,
    'F' => Feather
)


# TODO - Add more
entity_offsets = Dict{Union{Type, Function}, Tuple{Integer, Integer}}(
    SpikesUp => (0, 8),
    SpikesLeft => (8, 0),
    SpikesDown => (0, 0),
    SpikesRight => (0, 0),

    Player => (8, 8),

    DreamBlock => (0, 0),
    CrumbleBlock => (0, 0),

    JumpThru => (0, 0),

    GreenBooster => (4, 4),
    RedBooster => (4, 4),

    Refill => (4, 4),
    Feather => (4, 4),

    Water => (0, 0),

    Spinner => (4, 4),

    Bumper => (4, 4),

    Spring => (8, 8),
    SpringLeft => (0, 8),
    SpringRight => (8, 8),
)
# Function => (searchWidth, searchHeight)
search_for_size = Dict{Union{Type, Function}, Tuple{Bool, Bool}}(
    SpikesUp => (true, false),
    SpikesDown => (true, false),
    SpikesLeft => (false, true),
    SpikesRight => (false, true),

    DreamBlock => (true, true),
    CrumbleBlock => (true, false),
    DashBlock => (true, true),
    NegaBlock => (true, true),

    JumpThru => (true, false),

    Barrier => (true, true),

    Water => (true, true),

    Spinner => (false,  false),

    Refill => (false,  false),
    Feather => (false, false),

    GreenBooster => (false,  false),
    RedBooster => (false,  false),

    Spring => (false,  false),
    SpringLeft => (false,  false),
    SpringRight => (false,  false),

    Bumper => (false, false),
)

function searchSize(tiles::Array{Char, 2}, x::Integer, y::Integer, searchWidth::Bool=true, searchHeight::Bool=true)
    if !searchWidth && !searchHeight
        return 1, 1
    end

    c = tiles[y, x]
    height, width = size(tiles)

    stopX, stopY = x, y

    while searchWidth && stopX + 1 <= width && tiles[y, stopX + 1] == c
        stopX += 1
    end

    while searchHeight && stopY + 1 <= height && all(tiles[stopY + 1, x:stopX] .== c)
        stopY += 1
    end

    return stopX - x + 1, stopY - y + 1
end

entityMap(s::String, lookup::Dict{Char, Union{Type, Function}}=default_entity_map) = entityMap(Tiles(s).data, lookup)
entityMap(t::Tiles, lookup::Dict{Char, Union{Type, Function}}=default_entity_map) = entityMap(t.data, lookup)

function entityMap(tiles::Array{Char, 2}, lookup::Dict{Char, Union{Type, Function}}=default_entity_map)
    height, width = size(tiles)

    complete = fill(false, (height, width))

    res = Entity[]

    for y in 1:height
        for x in 1:width
            v = tiles[y, x]

            if !complete[y, x] && haskey(lookup, v)
                func = lookup[v]
                offset = haskey(entity_offsets, func) ? entity_offsets[func] : (0, 0)

                searchWidth, searchHeight = haskey(search_for_size, func) ? search_for_size[func] : (false, false)
                tileWidth, tileHeight = searchSize(tiles, x, y, searchWidth, searchHeight)

                complete[y:y + tileHeight - 1, x:x + tileWidth - 1] .= true

                if !searchWidth && !searchHeight
                    push!(res, func(x * 8 + offset[1] - 8, y * 8 + offset[2] - 8))

                elseif searchWidth && searchHeight
                    push!(res, func(x * 8 + offset[1] - 8, y * 8 + offset[2] - 8, tileWidth * 8, tileHeight * 8))

                elseif searchHeight
                    push!(res, func(x * 8 + offset[1] - 8, y * 8 + offset[2] - 8, tileHeight * 8))

                elseif searchWidth
                    push!(res, func(x * 8 + offset[1] - 8, y * 8 + offset[2] - 8, tileWidth * 8))
                end
            end
        end
    end

    return res
end