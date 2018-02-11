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

function Base.string(t::Tiles)
    return join(String.([t.data[i, :] for i in 1:size(t.data, 1)]), "\n")
end
