extends Node

var MAIN_VOLUME: float = 0.5
var SOUND_EFFECT_VOLUME: float = 0.5
var MUSIC_VOLUME: float = 0.5

var MOUSE_SENSITIVITY: float = 1.0
var FULLSCREEN: bool = false

func _ready() -> void:
	apply_audio_settings()
	apply_display_settings()

func apply_audio_settings() -> void:
	var master_idx = AudioServer.get_bus_index("Master")
	var sfx_idx = AudioServer.get_bus_index("SFX")
	var music_idx = AudioServer.get_bus_index("Music")
	
	AudioServer.set_bus_volume_db(master_idx, linear_to_db(MAIN_VOLUME))
	AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(SOUND_EFFECT_VOLUME))
	AudioServer.set_bus_volume_db(music_idx, linear_to_db(MUSIC_VOLUME))
	
func apply_display_settings() -> void:
	if FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func apply_mouse_sense() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	var raw_mouse_sense: float = SettingsManager.MOUSE_SENSITIVITY
	var mouse_sense: float = remap(raw_mouse_sense, 0.0, 1.0, 0.001, 0.008)
	
	player.mouse_sensitivity = mouse_sense
