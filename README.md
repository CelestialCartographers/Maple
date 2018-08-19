# Maple

This is Maple, a thin wrapper for generating map files for the game Celeste which can be loaded in the stock game or using [Everest](https://github.com/EverestAPI/Everest).
For usage without Everest you can replace a map in `Content/Maps` (remember backups), otherwise, you can place it in `Mods/<yourmodname>/Maps` with Everest and use the custom chapter loading. 

Improvements to user-friendliness are under development. Coding experience is required, but the tool should be rather easy to learn even if you know just the basics. If you want a visual editor, check out [Ahorn](https://github.com/CelestialCartographers/Ahorn), which is built on this.

This project is an unofficial level editor, it is merely a fan project aiming to aid map development until something official is available. None of this code is developed by or connected to the Celeste development team.

## Installation
Maple can be installed using julia's `Pkg` system.
```julia
julia> Pkg.clone("https://github.com/CelestialCartographers/Maple.git")
```
Maple can be updated using `Pkg.update()`.

## Usage

Maple can be imported like any other module.

```julia
using Maple
```

All objects in the map structure are represented using constructor functions. For examples, see the test directory. Documentation is currently not a priority, but you can check out the constructor names in `entity.jl` and `trigger.jl`.
Most constructor names are the same as the object names in the map binary put in CamelCase, but some might differ. Do note that the `x` and `y` position of certain objects may not be exactly what one would expect. Everything that isn't a block is currently not very predictable, and repeated testing may be needed. If you are serious about making maps, it is highly recommended to use [Everest](https://github.com/EverestAPI/Everest) for the F5 (force map reload) and F6 (open map editor for the current map) features.
