# Grabbed from Sfxs.cs
# These are the constant fields in the class and they seem to be correct

module Songs
macro songnames(s::Symbol, expr::Expr)
    return Expr(:block, esc(:($s = $expr)), [esc(:($(Meta.parse(k)) = $v)) for (k, v) in eval(expr)]...)
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
    "cas_08_core" => "event:/music/cassette/09_core",
    "music_farewell_part01" => "event:/new_content/music/lvl10/part01",
    "music_farewell_part02" => "event:/new_content/music/lvl10/part02",
    "music_farewell_part03" => "event:/new_content/music/lvl10/part03",
    "music_farewell_intermission_heartgroove" => "event:/new_content/music/lvl10/intermission_heartgroove",
    "music_farewell_intermission_powerpoint" => "event:/new_content/music/lvl10/intermission_powerpoint",
    "music_farewell_reconciliation" => "event:/new_content/music/lvl10/reconciliation",
    "music_farewell_cassette" => "event:/new_content/music/lvl10/cassette_rooms",
    "music_farewell_final_run" => "event:/new_content/music/lvl10/final_run",
    "music_farewell_end_cinematic" => "event:/new_content/music/lvl10/cinematic/end",
    "music_farewell_end_cinematic_intro" => "event:/new_content/music/lvl10/cinematic/end_intro",
    "music_farewell_firstbirdcrash_cinematic" => "event:/new_content/music/lvl10/cinematic/bird_crash_first",
    "music_farewell_secondbirdcrash_cinematic" => "event:/new_content/music/lvl10/cinematic/bird_crash_second",
    "music_farewell_granny" => "event:/new_content/music/lvl10/granny_farewell",
    "music_farewell_golden_room" => "event:/new_content/music/lvl10/golden_room",
))
end

module CassetteSongs
macro songnames(s::Symbol, expr::Expr)
    return Expr(:block, esc(:($s = $expr)), [esc(:($(Meta.parse(k)) = $v)) for (k, v) in eval(expr)]...)
end

@songnames(songs, Dict{String, String}(
    "cas_01_forsaken_city" => "event:/music/cassette/01_forsaken_city",
    "cas_02_old_site" => "event:/music/cassette/02_old_site",
    "cas_03_resort" => "event:/music/cassette/03_resort",
    "cas_04_cliffside" => "event:/music/cassette/04_cliffside",
    "cas_05_mirror_temple" => "event:/music/cassette/05_mirror_temple",
    "cas_06_reflection" => "event:/music/cassette/06_reflection",
    "cas_07_summit" => "event:/music/cassette/07_summit",
    "cas_08_core" => "event:/music/cassette/09_core",
    "music_farewell_cassette" => "event:/new_content/music/lvl10/cassette_rooms"
))
end

module EnvironmentSounds
macro soundnames(s::Symbol, expr::Expr)
    return Expr(:block, esc(:($s = $expr)), [esc(:($(Meta.parse(k)) = $v)) for (k, v) in eval(expr)]...)
end

@soundnames(sounds, Dict{String, String}(
    "env_loc_02_lamp" => "event:/env/local/02_old_site/phone_lamp",
    "env_loc_03_brokenwindow_large_loop" => "event:/env/local/03_resort/broken_window_large",
    "env_loc_03_brokenwindow_small_loop" => "event:/env/local/03_resort/broken_window_small",
    "env_loc_03_pico8machine_loop" => "event:/env/local/03_resort/pico8_machine",
    "env_loc_07_flag_flap" => "event:/env/local/07_summit/flag_flap",
    "env_loc_09_conveyer_idle" => "event:/env/local/09_core/conveyor_idle",
    "env_loc_09_fireball_idle" => "event:/env/local/09_core/fireballs_idle",
    "env_loc_09_lavagate_idle" => "event:/env/local/09_core/lavagate_idle",
    "env_loc_campfire_loop" => "event:/env/local/campfire_loop",
    "env_loc_campfire_start" => "event:/env/local/campfire_start",
    "env_loc_waterfall_big_in" => "event:/env/local/waterfall_big_in",
    "env_loc_waterfall_big_main" => "event:/env/local/waterfall_big_main",
    "env_loc_waterfall_small_in_deep" => "event:/env/local/waterfall_small_in_deep",
    "env_loc_waterfall_small_in_shallow" => "event:/env/local/waterfall_small_in_shallow",
    "env_loc_waterfall_small_main" => "event:/env/local/waterfall_small_main",
    "env_loc_10_cafe_computer" => "event:/new_content/env/local/cafe_computer",
    "env_loc_10_cafe_sign" => "event:/new_content/env/local/cafe_sign",
    "env_loc_10_tutorial_static_left" => "event:/new_content/env/local/tutorial_static_left",
    "env_loc_10_tutorial_static_right" => "event:/new_content/env/local/tutorial_static_right",
    "env_loc_10_kevinpc" => "event:/new_content/env/local/kevinpc",
))
end

module AmbientSounds
macro soundnames(s::Symbol, expr::Expr)
    return Expr(:block, esc(:($s = $expr)), [esc(:($(Meta.parse(k)) = $v)) for (k, v) in eval(expr)]...)
end

@soundnames(sounds, Dict{String, String}(
    "env_amb_00_main" => "event:/env/amb/00_prologue",
    "env_amb_01_main" => "event:/env/amb/01_main",
    "env_amb_02_awake" => "event:/env/amb/02_awake",
    "env_amb_02_dream" => "event:/env/amb/02_dream",
    "env_amb_03_exterior" => "event:/env/amb/03_exterior",
    "env_amb_03_interior" => "event:/env/amb/03_interior",
    "env_amb_03_pico8_closeup" => "event:/env/amb/03_pico8_closeup",
    "env_amb_04_main" => "event:/env/amb/04_main",
    "env_amb_05_interior_dark" => "event:/env/amb/05_interior_dark",
    "env_amb_05_interior_main" => "event:/env/amb/05_interior_main",
    "env_amb_05_mirror_sequence" => "event:/env/amb/05_mirror_sequence",
    "env_amb_06_lake" => "event:/env/amb/06_lake",
    "env_amb_06_main" => "event:/env/amb/06_main",
    "env_amb_06_prehug" => "event:/env/amb/06_prehug",
    "env_amb_09_main" => "event:/env/amb/09_main",
    "env_amb_worldmap" => "event:/env/amb/worldmap",
    "env_amb_10_rain" => "event:/new_content/env/10_rain",
    "env_amb_10_electricity" => "event:/new_content/env/10_electricity",
    "env_amb_10_endscene" => "event:/new_content/env/10_endscene",
    "env_amb_10_rushingvoid" => "event:/new_content/env/10_rushingvoid",
    "env_amb_10_space_underwater" => "event:/new_content/env/10_space_underwater",
    "env_amb_10_voidspiral" => "event:/new_content/env/10_voidspiral",
    "env_amb_10_grannyclouds" => "event:/new_content/env/10_grannyclouds",
))
end

const tileset_sound_ids = Dict{String, Int}(
    "Default" => -1,
    "Null" => 0,
    "Asphalt" => 1,
    "Car" => 2,
    "Dirt" => 3,
    "Snow" => 4,
    "Wood" => 5,
    "Bridge" => 6,
    "Girder" => 7,
    "Brick" => 8,
    "Zip Mover" => 9,
    "Space Jam (Inactive)" => 11,
    "Space Jam (Active)" => 12,
    "Resort Wood" => 13,
    "Resort Roof" => 14,
    "Resort Platform" => 15,
    "Resort Basement" => 16,
    "Resort Laundry" => 17,
    "Resort Boxes" => 18,
    "Resort Books" => 19,
    "Resort Forcefield" => 20,
    "Resort Clutterswitch" => 21,
    "Resort Elevator" => 22,
    "Cliffside Snow" => 23,
    "Cliffside Grass" => 25,
    "Cliffside Whiteblock" => 27,
    "Gondola" => 28,
    "Glass" => 32,
    "Grass" => 33,
    "Cassette Block" => 35,
    "Core Ice" => 36,
    "Core Rock" => 37,
    "Glitch" => 40,
    "Internet Café" => 42,
    "Cloud" => 43,
    "Moon" => 44
)

const wind_patterns = String[
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

const temple_gate_modes = String[
    "NearestSwitch",
    "CloseBehindPlayer",
    "CloseBehindPlayerAlways",
    "HoldingTheo",
    "TouchSwitches",
    "CloseBehindPlayerAndTheo"
]

const bird_npc_modes = String[
    "ClimbingTutorial",
    "DashingTutorial",
    "DreamJumpTutorial",
    "SuperWallJumpTutorial",
    "HyperJumpTutorial",
    "FlyAway",
    "Sleeping",
    "MoveToNodes",
    "WaitForLightningOff",
    "None"
]

const everest_bird_tutorial_tutorials = String[
    "TUTORIAL_CLIMB",
    "TUTORIAL_HOLD",
    "TUTORIAL_DASH",
    "TUTORIAL_DREAMJUMP",
    "TUTORIAL_CARRY",
    "hyperjump/tutorial00",
    "hyperjump/tutorial01"
]

const bonfire_modes = String[
    "Unlit",
    "Lit",
    "Smoking"
]

const clutter_block_colors = String[
    "Red",
    "Green",
    "Yellow"
]

# Core and Rainbow color added by Everest
const crystal_colors = String[
    "Blue",
    "Red",
    "Purple",
    "Core",
    "Rainbow"
]

const dash_switch_sides = String[
    "Up",
    "Down",
    "Left",
    "Right"
]

const tentacle_sides = String[
    "Up",
    "Down",
    "Left",
    "Right"
]

const tentacle_fear_distance = String[
    "close",
    "medium",
    "far"
]

const move_block_directions = String[
    "Up",
    "Down",
    "Left",
    "Right"
]

const spike_directions = String[
    "Up",
    "Down",
    "Left",
    "Right"
]

const tentacle_effect_directions = String[
    "Up",
    "Down",
    "Left",
    "Right"
]

const planet_effect_sizes = String[
    "big",
    "small"
]

const trigger_spike_directions = String[
    "Up",
    "Down",
    "Left",
    "Right"
]

const spring_orientations = String[
    "Floor",
    "WallLeft",
    "WallRight"
]

const track_spinner_speeds = String[
    "Slow",
    "Normal",
    "Fast"
]

const fake_wall_modes = String[
    "Wall",
    "Block"
]

const condition_block_conditions = String[
    "Key",
    "Button",
    "Strawberry"
]

const spike_types = String[
    "default",
    "outline",
    "cliffside",
    "tentacles",
    "reflection"
]

const crumble_block_textures = String[
    "default",
    "cliffside"
]

const wood_platform_textures = String[
    "default",
    "cliffside"
]

const kevin_axes = String[
    "both",
    "horizontal",
    "vertical"
]

const npc_npcs = String[
    "granny_00_house",
    "theo_01_campfire",
    "theo_02_campfire",
    "theo_03_escaping",
    "theo_03_vents",
    "oshiro_03_lobby",
    "oshiro_03_hallway",
    "oshiro_03_hallway2",
    "oshiro_03_bigroom",
    "oshiro_03_breakdown",
    "oshiro_03_suite",
    "oshiro_03_rooftop",
    "granny_04_cliffside",
    "theo_04_cliffside",
    "theo_05_entrance",
    "theo_05_inmirror",
    "evil_05",
    "theo_06_plateau",
    "granny_06_intro",
    "badeline_06_crying",
    "granny_06_ending",
    "theo_06_ending",
    "granny_07x",
    "theo_08_inside",
    "granny_08_inside",
    "granny_09_outside",
    "granny_09_inside",
    "gravestone_10",
    "granny_10_never"
]

const seeker_statue_hatches = String[
    "Distance",
    "PlayerRightOfX"
]

const badeline_boss_shooting_patterns = Int[
    0, 1, 2, 3, 4,
    5, 6, 7, 8, 9, 
    10, 11, 12, 13, 14,
    15
]

const tile_entity_legal_tiles = Char[
    '1', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd',
    'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l'
]

const slider_surfaces = String[
    "Ceiling",
    "LeftWall",
    "RightWall",
    "Floor"
]

const trigger_position_modes = String[
    "HorizontalCenter",
    "VerticalCenter",
    "TopToBottom",
    "BottomToTop",
    "LeftToRight",
    "RightToLeft",
    "NoEffect"
]

const event_trigger_events = String[
    "end_city",
    "end_oldsite_dream",
    "end_oldsite_awake",
    "ch5_see_theo",
    "ch5_found_theo",
    "ch5_mirror_reflection",
    "cancel_ch5_see_theo",
    "ch6_boss_intro",
    "ch6_reflect",
    "ch7_summit",
    "ch8_door",
    "ch9_goto_the_future",
    "ch9_goto_the_past",
    "ch9_moon_intro",
    "ch9_hub_intro",
    "ch9_hub_transition_out",
    "ch9_badeline_helps",
    "ch9_farewell",
    "ch9_ending",
    "ch9_end_golden",
    "ch9_final_room",
    "ch9_ding_ding_ding",
    "ch9_golden_snapshot"
]

const mini_textbox_trigger_modes = String[
    "OnPlayerEnter",
    "OnLevelStart",
    "OnTheoEnter"
]

const everest_flag_trigger_modes = String[
    "OnPlayerEnter",
    "OnPlayerLeave",
    "OnLevelStart"
]

const everest_crystal_shatter_trigger_modes = String[
    "All",
    "Contained"
]

const everest_fake_heart_colors = String[
    "Normal",
    "BSide",
    "CSide",
    "Random"
]

const music_fade_trigger_directions = String[
    "leftToRight",
    "topToBottom"
]

const black_hole_trigger_strengths = String[
    "Mild",
    "Medium",
    "High",
    "Wild"
]

const moon_glitch_background_trigger_durations = String[
    "Short",
    "Medium",
    "Long"
]

const spawn_facing_trigger_facings = String[
    "Right",
    "Left"
]

const zip_mover_themes = String[
    "Normal",
    "Moon"
]

const swap_block_themes = String[
    "Normal",
    "Moon"
]