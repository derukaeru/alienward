extends Control

func change_main_volume(value: float) -> void:
	SettingsManager.MAIN_VOLUME = value

func change_sound_effect_volume(value: float) -> void:
	SettingsManager.SOUND_EFFECT_VOLUME = value

func change_music_volume(value: float) -> void:
	SettingsManager.MUSIC_VOLUME = value

func change_sensitivity(value: float) -> void:
	SettingsManager.MOUSE_SENSITIVITY = value

func change_fullscreen(value: bool) -> void:
	SettingsManager.FULLSCREEN = value
