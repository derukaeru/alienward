extends Control

@onready var background_poly: Polygon2D = $background_poly
@onready var background_poly_2: Polygon2D = $background_poly_2

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var star: TextureRect = $star

func _ready() -> void:
	update_data()

func update_data() -> void:
	$main_volume_slider.value = SettingsManager.MAIN_VOLUME
	$music_slider.value = SettingsManager.MUSIC_VOLUME
	$sound_effect_volume_slider.value = SettingsManager.SOUND_EFFECT_VOLUME
	
	$sensitivity_slider.value = SettingsManager.MOUSE_SENSITIVITY
	$fullscreen_button.button_pressed = SettingsManager.FULLSCREEN

func _process(delta) -> void:
	star.rotation_degrees += 20 * delta
	if star.rotation_degrees > 360:
		star.rotation_degrees = 0

func change_poly_position(value: Vector2, vertex_index: int, polygon: Polygon2D) -> void:
	var vertices: PackedVector2Array = polygon.polygon
	vertices[vertex_index] = value
	
	polygon.polygon = vertices

func change_main_volume(value: float) -> void:
	SettingsManager.MAIN_VOLUME = value
	SettingsManager.apply_audio_settings()

func change_sound_effect_volume(value: float) -> void:
	SettingsManager.SOUND_EFFECT_VOLUME = value
	SettingsManager.apply_audio_settings()

func change_music_volume(value: float) -> void:
	SettingsManager.MUSIC_VOLUME = value
	SettingsManager.apply_audio_settings()

func change_sensitivity(value: float) -> void:
	SettingsManager.MOUSE_SENSITIVITY = value
	SettingsManager.apply_mouse_sense()

func change_fullscreen(value: bool) -> void:
	SettingsManager.FULLSCREEN = value
	SettingsManager.apply_display_settings()
