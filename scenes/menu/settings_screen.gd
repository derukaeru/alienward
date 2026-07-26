extends Control

func _ready() -> void:
	$main_volume_slider.value = SettingsManager.MAIN_VOLUME
	$music_slider.value = SettingsManager.MUSIC_VOLUME
	$sound_effect_volume_slider.value = SettingsManager.SOUND_EFFECT_VOLUME
	
	
	$sensitivity_slider.value = SettingsManager.MOUSE_SENSITIVITY
	$fullscreen_button.button_pressed = SettingsManager.FULLSCREEN

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

func _on_exit_pressed() -> void:
	hide()
