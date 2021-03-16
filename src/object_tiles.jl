@valueequals mutable struct ObjectTiles
    data::Array{Int, 2}

    ObjectTiles() = new(fill(-1, (40, 23)))

    ObjectTiles(d::Array{Int, 2}) = new(d)

    function ObjectTiles(s::String)
        s = chomp(replace(s, "\r\n" => "\n"))
        lines = split(s, "\n")
        lineLengths = length.(split.(lines, ','))

        cols = maximum(lineLengths)
        rows = length(lines)

        res = fill(-1, rows, cols)

        for (i, line) in enumerate(lines)
            if isempty(line)
                continue
            end

            res[i, 1:lineLengths[i]] = parse.(Int, split(line, ','))
        end

        return new(res)
    end
end

function Base.string(t::ObjectTiles)
    return join(join.([t.data[i, :] for i in 1:size(t.data, 1)], ','), "\n")
end