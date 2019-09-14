macro exportalltypes()
    return Expr(:export, filter(val -> match(r"#|@|(^[a-z])", string(val)) === nothing, names(Maple, all=true))...)
end

function unwrapType(T::Expr)::Symbol
    @assert T.head in (:curly, :(<:))
    unwrapType(T.args[1])
end

unwrapType(s::Symbol)::Symbol = s

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