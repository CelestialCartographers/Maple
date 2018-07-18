# Grabbed from Sfxs.cs
# These are the constant fields in the class and they seem to be correct
module Songs
macro songnames(s::Symbol, expr::Expr)
    return Expr(:block, esc(:($s = $expr)), [esc(:($(parse(k)) = $v)) for (k, v) in eval(expr)]...)
end

@songnames(songs, Dict{String, String}(
    "music_levelselect" => "event:/music/menu/level_select",
    "music_credits" => "event:/music/menu/credits",
    "music_complete_area" => "event:/music/menu/complete_area",
    "music_complete_summit" => "event:/music/menu/complete_summit",
    "music_complete_bside" => "event:/music/menu/complete_bside",
    "music_prologue_intro_vignette" => "event:/game/00_prologue/intro_vignette",
    "music_prologue_beginning" => "event:/music/lvl0/intro",
    "music_prologue_collapse" => "event:/music/lvl0/bridge",
    "music_prologue_title_ping" => "event:/music/lvl0/title_ping",
    "music_city" => "event:/music/lvl1/main",
    "music_city_theo" => "event:/music/lvl1/theo",
    "music_oldsite_beginning" => "event:/music/lvl2/beginning",
    "music_oldsite_mirror" => "event:/music/lvl2/mirror",
    "music_oldsite_dreamblock_sting_pt1" => "event:/music/lvl2/dreamblock_sting_pt1",
    "music_oldsite_dreamblock_sting_pt2" => "event:/music/lvl2/dreamblock_sting_pt2",
    "music_oldsite_evil_maddy" => "event:/music/lvl2/evil_madeline",
    "music_oldsite_chase" => "event:/music/lvl2/chase",
    "music_oldsite_payphone_loop" => "event:/music/lvl2/phone_loop",
    "music_oldsite_payphone_end" => "event:/music/lvl2/phone_end",
    "music_oldsite_awake" => "event:/music/lvl2/awake",
    "music_resort_intro" => "event:/music/lvl3/intro",
    "music_resort_explore" => "event:/music/lvl3/explore",
    "music_resort_clean" => "event:/music/lvl3/clean",
    "music_resort_clean_extended" => "event:/music/lvl3/clean_extended",
    "music_resort_oshiro_theme" => "event:/music/lvl3/oshiro_theme",
    "music_resort_oshiro_chase" => "event:/music/lvl3/oshiro_chase",
    "music_cliffside_main" => "event:/music/lvl4/main",
    "music_cliffside_heavywinds" => "event:/music/lvl4/heavy_winds",
    "music_cliffside_panicattack" => "event:/music/lvl4/minigame",
    "music_temple_normal" => "event:/music/lvl5/normal",
    "music_temple_middle" => "event:/music/lvl5/middle_temple",
    "music_temple_mirror" => "event:/music/lvl5/mirror",
    "music_temple_mirrorcutscene" => "event:/music/lvl5/mirror_cutscene",
    "music_reflection_maddietheo" => "event:/music/lvl6/madeline_and_theo",
    "music_reflection_starjump" => "event:/music/lvl6/starjump",
    "music_reflection_fall" => "event:/music/lvl6/the_fall",
    "music_reflection_fight" => "event:/music/lvl6/badeline_fight",
    "music_reflection_fight_glitch" => "event:/music/lvl6/badeline_glitch",
    "music_reflection_fight_finish" => "event:/music/lvl6/badeline_acoustic",
    "music_reflection_main" => "event:/music/lvl6/main",
    "music_reflection_secretroom" => "event:/music/lvl6/secret_room",
    "music_summit_main" => "event:/music/lvl7/main",
    "music_summit_finalascent" => "event:/music/lvl7/final_ascent",
    "music_epilogue_main" => "event:/music/lvl8/main",
    "music_core_main" => "event:/music/lvl9/main",
    "music_pico8_title" => "event:/classic/pico8_mus_00",
    "music_pico8_area1" => "event:/classic/pico8_mus_01",
    "music_pico8_area2" => "event:/classic/pico8_mus_02",
    "music_pico8_area3" => "event:/classic/pico8_mus_03",
    "music_pico8_wind" => "event:/classic/sfx61",
    "music_pico8_end" => "event:/classic/sfx62",
    "music_pico8_boot" => "event:/classic/pico8_boot",
    "music_rmx_01_forsaken_city" => "event:/music/remix/01_forsaken_city",
    "music_rmx_02_old_site" => "event:/music/remix/02_old_site",
    "music_rmx_03_resort" => "event:/music/remix/03_resort",
    "music_rmx_04_cliffside" => "event:/music/remix/04_cliffside",
    "music_rmx_05_mirror_temple" => "event:/music/remix/05_mirror_temple",
    "music_rmx_06_reflection" => "event:/music/remix/06_reflection",
    "music_rmx_07_summit" => "event:/music/remix/07_summit",
    "music_rmx_09_core" => "event:/music/remix/09_core",
    "cas_01_forsaken_city" => "event:/music/cassette/01_forsaken_city",
    "cas_02_old_site" => "event:/music/cassette/02_old_site",
    "cas_03_resort" => "event:/music/cassette/03_resort",
    "cas_04_cliffside" => "event:/music/cassette/04_cliffside",
    "cas_05_mirror_temple" => "event:/music/cassette/05_mirror_temple",
    "cas_06_reflection" => "event:/music/cassette/06_reflection",
    "cas_07_summit" => "event:/music/cassette/07_summit",
    "cas_08_core" => "event:/music/cassette/09_core"
))
end

windpatterns = [
    "None",
    "Left",
    "Right",
    "LeftStrong",
    "RightStrong",
    "LeftOnOff",
    "RightOnOff",
    "LeftOnOffFast",
    "RightOnOffFast",
    "Alternating",
    "LeftGemsOnly",
    "RightCrazy",
    "Down",
    "Up",
    "Space"
]

temple_gate_modes = [
    "NearestSwitch",
    "CloseBehindPlayer",
    "CloseBehindPlayerAlways",
    "HoldingTheo",
    "TouchSwitches",
    "CloseBehindPlayerAndTheo"
]

bird_npc_modes = [
    "ClimbingTutorial",
    "DashingTutorial",
    "DreamJumpTutorial",
    "SuperWallJumpTutorial",
    "HyperJumpTutorial",
    "FlyAway",
    "None",
    "Sleeping"
]

bonfire_modes = [
    "Unlit",
    "Lit",
    "Smoking"
]

clutter_block_colors = [
    "Red",
    "Green",
    "Yellow"
]

# Core color added by Everest
crystal_colors = [
    "Blue",
    "Red",
    "Purple",
    "Core"
]

dash_switch_sides = [
    "Up",
    "Down",
    "Left",
    "Right"
]

move_block_directions = [
    "Up",
    "Down",
    "Left",
    "Right"
]

spike_directions = [
    "Up",
    "Down",
    "Left",
    "Right"
]

trigger_spike_directions = [
    "Up",
    "Down",
    "Left",
    "Right"
]

spring_orientations = [
    "Floor",
    "WallLeft",
    "WallRight"
]

track_spinner_speeds = [
    "Slow",
    "Normal",
    "Fast"
]

fake_wall_modes = [
    "Wall",
    "Block"
]

badeline_boss_shooting_patterns = [
    0, 1, 2, 3, 4,
    5, 6, 7, 8, 9, 
    10, 11, 12, 13, 14,
    15
]

tile_entity_legal_tiles = [
    '1', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd',
    'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l'
]