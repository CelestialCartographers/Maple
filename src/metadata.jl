include("map.jl")

safe_string(s::String) = "\"$s\""

yaml(buf::IOBuffer, s::String, indent::Integer = 0; list::Bool = false) = write(buf, (list ? " "^max(0, indent - 2) * "- " : " "^indent) * s)
yaml(buf::IOBuffer, k::String, v::String, indent::Integer = 0; list::Bool = false, unsafe::Bool = false) = yaml(buf, "$k: $(unsafe ? v : safe_string(v))\n", indent, list = list)
yaml(buf::IOBuffer, k::String, v::Bool, indent::Integer = 0; list::Bool = false) = yaml(buf, "$k: $(string(v))\n", indent, list = list)
yaml(buf::IOBuffer, k::String, v::Enum, indent::Integer = 0; list::Bool = false) = yaml(buf, "$k: $(safe_string(string(v)))\n", indent, list = list)
yaml(buf::IOBuffer, k::String, t::NTuple{N, AbstractFloat} where N, indent::Integer = 0) = yaml(buf, "$k: [$(join(t, ", "))]\n", indent)

struct CompleteScreenLayer
    name::String
    images::Array{String, 1}
    position::NTuple{2, AbstractFloat}
    scroll:: NTuple{2, AbstractFloat}
end

function yaml(buf::IOBuffer, l::CompleteScreenLayer, indent::Integer = 0)
    yaml(buf, "Type", l.name, indent, list=true)
    yaml(buf, "Images", "[$(join(safe_string.(l.images), ", "))]", indent)
    yaml(buf, "Position", l.position, indent)
    yaml(buf, "Scroll", l.scroll, indent)
end

struct CompleteScreen
    atlas::String
    start::NTuple{2, AbstractFloat}
    center::NTuple{2, AbstractFloat}
    offset::NTuple{2, AbstractFloat}
    layers::Array{CompleteScreenLayer, 1}
end

function yaml(buf::IOBuffer, k::String, s::CompleteScreen, indent::Integer = 0)
    yaml(buf, "$k:\n", indent)
    indent += 4
    yaml(buf, "Atlas", s.atlas, indent)
    yaml(buf, "Start", s.start, indent)
    yaml(buf, "Center", s.center, indent)
    yaml(buf, "Offset", s.offset, indent)

    # Write the layers
    yaml(buf, "Layers:\n", indent)
    indent += 4
    for layer in s.layers
        yaml(buf, layer, indent)
    end
end

module MountainTime
@enum Time Night Dawn Morning
end

struct MountainCam
    position::NTuple{3, AbstractFloat}
    target::NTuple{3, AbstractFloat}
end

function yaml(buf::IOBuffer, k::String, m::MountainCam, indent::Integer = 0)
    yaml(buf, "$k:\n", indent)
    indent += 4
    yaml(buf, "Position", m.position, indent)
    yaml(buf, "Target", m.target, indent)
end

struct Mountain
    idle::MountainCam
    select::MountainCam
    zoom::MountainCam
    cursor::NTuple{3, AbstractFloat}
    state::MountainTime.Time
end

function yaml(buf::IOBuffer, k::String, m::Mountain, indent::Integer = 0)
    yaml(buf, "$k:\n", indent)
    indent += 4
    yaml(buf, "Idle", m.idle, indent)
    yaml(buf, "Select", m.select, indent)
    yaml(buf, "Zoom", m.zoom, indent)
    yaml(buf, "Cursor", m.cursor, indent)
    yaml(buf, "State", string(Int32(m.state)), indent, unsafe = true)
end

module IntroTypes
@enum IntroType Respawn WalkInRight WalkInLeft Jump WakeUp Fall TempleMirrorVoid None
end

module ColorGrades
@enum ColorGrade oldsite reflection
end

module Songs
songNames = String[
    "event:/music/cassette/01_forsaken_city",
    "event:/music/cassette/02_old_site",
    "event:/music/cassette/03_resort",
    "event:/music/cassette/04_cliffside",
    "event:/music/cassette/05_mirror_temple",
    "event:/music/cassette/06_reflection",
    "event:/music/cassette/07_summit",
    "event:/music/cassette/09_core"
]
@enum Song ForsakenCity=1 OldSite=2 Resort=3 Cliffside=4 MirrorTemple=5 Reflection=6 Summit=7 Core=8
Base.getindex(a::Array{String, 1}, s::Songs.Song) = getindex(a, convert(Int32, s))
end

yaml(buf::IOBuffer, k::String, v::Songs.Song, indent::Integer = 0) = yaml(buf, "$k: $(safe_string(Songs.songNames[v]))\n", indent)

module Inventories
@enum Inventory Default CH6End Core OldSite Prologue TheSummit
end

struct Side
    map::Map
    inventory::Inventories.Inventory
    # TODO Checkpoints, audio state, poem ID?
end

function yaml(buf::IOBuffer, s::Side, indent::Integer = 0)
    yaml(buf, "Path", s.map.package, indent, list=true)
    yaml(buf, "Inventory", s.inventory, indent)
end

struct Chapter
    name::String
    id::String
    sides::NTuple{3, Union{Side, Void}}
    data::Dict{String, Any}

    Chapter(
        name::String,
        id::String = name;
        icon::String = "",
        interlude::Bool = false,
        completeScreen::Union{CompleteScreen, Void} = nothing,
        completeScreenName::String = "",
        titleBaseColor::Union{UInt32, Void} = nothing,
        titleAccentColor::Union{UInt32, Void} = nothing,
        titleTextColor::Union{UInt32, Void} = nothing,
        introType::Union{IntroTypes.IntroType, Void} = nothing,
        colorGrade::Union{ColorGrades.ColorGrade, Void} = nothing,
        cassetteNoteColor::Union{UInt32, Void} = nothing,
        cassetteSong::Union{Songs.Song, Void} = nothing,
        sideA::Union{Side, Void} = nothing,
        sideB::Union{Side, Void} = nothing,
        sideC::Union{Side, Void} = nothing,
        mountain::Union{Mountain, Void} = nothing
    ) = new(name, id, (sideA, sideB, sideC), filter(Dict{String, Any}(
            "Icon" => icon,
            "Interlude" => interlude,
            "CompleteScreen" => completeScreen,
            "CompleteScreenName" => completeScreenName,
            "TitleBaseColor" => titleBaseColor,
            "TitleAccentColor" => titleAccentColor,
            "TitleTextColor" => titleTextColor,
            "IntroType" => introType,
            "ColorGrade" => colorGrade,
            "CassetteNoteColor" => cassetteNoteColor,
            "CassetteSong" => cassetteSong,
            "Mountain" => mountain
    )) do x, v
        v !== nothing && !(isa(v, String) && isempty(v))
    end)
end

function yaml(buf::IOBuffer, c::Chapter, indent::Integer = 0; sid::String = "1-$(c.name)")
    yaml(buf, "Name", c.name, indent)
    yaml(buf, "SID", sid, indent)
    for (k, v) in enumerate(c.data)
        if isa(v[2], UInt32)
            yaml(buf, v[1], num2hex(v[2])[end-5:end], indent)
        else
            yaml(buf, v[1], v[2], indent)
        end
    end

    # Write the modes
    yaml(buf, "Modes:\n", indent)
    indent += 4
    for side in c.sides
        if side !== nothing
            yaml(buf, side, indent)
        end
    end
end

struct Story
    name::String
    chapters::Array{Chapter, 1}

    Story(name::String, chapters::Array{Chapter, 1}) = new(name, chapters)
    Story(name::String, chapters::Chapter...) = new(name, [c for c in chapters])
end

function yaml(s::Story, indent::Integer = 0)
    for (i, c) in enumerate(s.chapters)
        buf = IOBuffer()
        yaml(buf, c, sid = "$(s.name)/$i-$(c.id)")
        # TODO write to file
        println(String(buf))
    end
end