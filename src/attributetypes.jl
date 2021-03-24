const preferredTypes = Dict{Expr, Dict{String, Union{Symbol, Expr}}}()

function getPreferredType(T::Type, attr::String)::Union{Type, Nothing}
    MT = nameof(T)
    ST = Meta.quot(T.parameters[1])

    expr = :($MT{$ST})

    if haskey(preferredTypes, expr) && haskey(preferredTypes[expr], attr)
        return eval(preferredTypes[expr][attr])
    end

    return nothing
end

getPreferredType(obj, attr::String)::Union{Type, Nothing} = getPreferredType(typeof(obj), attr)