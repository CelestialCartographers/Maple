macro exportalltypes()
    return Expr(:export, filter(val -> match(r"#|@|(^[a-z])", string(val)) === nothing, names(Maple, all=true))...)
end

function unwrapType(T::Expr)::Symbol
    @assert T.head in (:curly, :(<:))
    unwrapType(T.args[1])
end

unwrapType(s::Symbol)::Symbol = s

# Macro to proxy indexing of a type to one of its fields

macro fieldproxy(expr, field::Symbol=:data)
    while expr.head == :macrocall
        expr = length(expr.args) >= 3 ? expr.args[3] : expr.args[2]
    end

    T = unwrapType(expr.args[2])

    @assert T isa Symbol
    @assert expr.head == :struct

    qf = Meta.quot(field)

    quote
        $expr

        Base.getproperty(t::$T, s::Symbol) = isdefined(t, s) ? getfield(t, s) : getfield(t, $qf)[string(s)]
        Base.setproperty!(t::$T, s::Symbol, v) = isdefined(t, s) ? setfield!(t, s, v) : (getfield(t, $qf)[string(s)] = v)

        Base.get(t::$T, key, default) = get(getfield(t, $qf), key, default)
        Base.get!(t::$T, key, default) = get!(getfield(t, $qf), key, default)
        Base.get(f::Function, t::$T, key) = get(f, getfield(t, $qf), key)
        Base.get!(f::Function, t::$T, key) = get!(f, getfield(t, $qf), key)

        Base.getindex(t::$T, k::String) = getindex(getfield(t, $qf), k)
        Base.setindex!(t::$T, k::String, v) = setindex!(getfield(t, $qf), k, v)
        Base.isempty(t::$T) = isempty(getfield(t, $qf))
        Base.length(t::$T) = length(getfield(t, $qf))
    end |> esc
end

# Macro to make generating entities and triggers easier

# Unwrap a variable's type in a method definition
function getType(expr::Expr)
    if expr.head == :(::)
        return expr.args[1], expr.args[2]
    elseif expr.head == :kw
        return getType(expr.args[1])
    elseif expr.head == :parameters
        return getType.(expr.args)
    else
        throw(AssertionError("Not a valid type declaration at $expr"))
    end
end

getType(s::Symbol) = nothing

# Get all preferred types of a definition
function getPreferredTypes(T::Expr)
    typedata = T.args[2:end]
    attrtypes = Dict{String, Union{Symbol, Expr}}()
    types = getType.(T.args[2:end])
    for typ in types
        if typ isa Array
            for (vn, vt) in typ
                attrtypes[String(vn)] = vt
            end
        elseif typ !== nothing
            attrtypes[String(typ[1])] = typ[2]
        end
    end
    return attrtypes
end

firstchild(expr::Expr) = expr.args[findfirst(a -> !isa(a, LineNumberNode), expr.args)]
unwrapBlock(expr::Expr) = expr.head == :block ? unwrapBlock(firstchild(expr)) : expr

macro pardef(makeConst::Bool, expr)
    expr = macroexpand(__module__, expr)
    @assert expr.head == :(=)
    f = unwrapBlock(expr.args[1])
    v = unwrapBlock(expr.args[2])

    T = f.args[1]
    qT = Meta.quot(Symbol(v.args[2]))
    V = v.args[1]

    if v.head != :curly
        v.args[1] = :($V{$qT})
    end

    # Add type information to index
    attrtypes = getPreferredTypes(f)
    preferredTypes[:($V{$qT})] = attrtypes

    if makeConst
        quote
            const $T = $V{$qT}
            $f = $v
        end
    else
        :($f = $v)
    end |> esc
end

macro pardef(expr)
    :(@pardef true $expr) |> esc
end

function stripTypeDeclaration(expr::Expr)
    if expr.head == :(::)
        var = expr.args[1]
        return Expr(:kw, var, var)
    elseif expr.head == :kw
        return stripTypeDeclaration(expr.args[1])
    elseif expr.head == :parameters
        return stripTypeDeclaration.(expr.args)
    else
        throw(AssertionError("Not a valid type declaration at $expr"))
    end
end

stripTypeDeclaration(var::Symbol) = Expr(:kw, var, var)

macro kwproxy(type::Symbol, id::String, expr)
    @assert expr.head == :call
    kwargs = foldl(stripTypeDeclaration.(expr.args[2:end]), init=[]) do arr, param
        if param isa Array
            append!(arr, param)
        else
            push!(arr, param)
        end
    end
    :($expr = $type($id, $(kwargs...))) |> esc
end

macro mapdef(makeConst::Bool, e...)
    :(@pardef $makeConst @kwproxy $(e...)) |> esc
end

macro mapdef(e...)
    :(@mapdef true $(e...)) |> esc
end

# Used to escape normally illegal keywords like 'global'.
macro kwesc(n::QuoteNode)
    return n.value |> esc
end

# Macro to automatically generate == and hash() comparing all fields in a type

function addValid(fields, f, filter)
    if f ∉ filter
        push!(fields, f)
    end
end

function getFields(args, filter)
    fields = Symbol[]
    for f in args
        if f isa Symbol
            addValid(fields, f, filter)
        elseif f isa Expr && f.head == :(::)
            addValid(fields, f.args[1], filter)
        end
    end
    return fields
end

function equals(fields::Array{Symbol}, i=length(fields))
    if i == 1
        :(lhs.$(fields[i]) == rhs.$(fields[i]))
    else
        :($(equals(fields, i - 1)) && lhs.$(fields[i]) == rhs.$(fields[i]))
    end
end

function hashes(fields::Array{Symbol}, i=length(fields))
    if i == 1
        :(hash(s.$(fields[i]), h))
    else
        :(hash(s.$(fields[i]), $(hashes(fields, i - 1))))
    end
end

function unwrapTypeBlock(expr)
    if expr.head == :struct
        return expr
    elseif expr.head == :block
        for ex in expr.args
            if ex isa Expr
                ex_u = unwrapTypeBlock(ex)
                if ex_u !== nothing
                    return ex_u
                end
            end
        end
    end
    return nothing
end

macro valueequals(filter, expr)
    expr = macroexpand(__module__, expr)
    orig_expr = expr
    expr = unwrapTypeBlock(expr)
    @assert expr !== nothing

    @assert filter.head == :vect
    filter_arr = filter.args

    @assert expr.head == :struct
    T = unwrapType(expr.args[2])
    fields = getFields(expr.args[3].args, filter_arr)

    if length(fields) == 0
        orig_expr |> esc
    else
        quote
            $orig_expr

            @inline Base.:(==)(lhs::$T, rhs::$T) = $(equals(fields))
            @inline Base.hash(s::$T, h::UInt) = $(hashes(fields))
        end |> esc
    end
end

macro valueequals(expr)
    :(@valueequals [] $expr) |> esc
end