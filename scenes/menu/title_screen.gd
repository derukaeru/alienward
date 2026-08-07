extends Control

@onready var scrolling_background: TextureRect = $scrolling_background
@onready var animation: AnimationPlayer = $AnimationPlayer

@onready var star: TextureRect = $star

@onready var main_menu: Control = $main_menu
@onready var start_menu: Control = $start_menu

@onready var settings_screen: Control = $settings_screen
@onready var seed_label: LineEdit = $start_menu/seed_info/seed

@onready var selector_poly: Polygon2D = $selector_poly
@onready var settings_exit: Button = $settings_screen/settings_exit

var default_poly_vertex_1: Vector2 = Vector2(250.0, 75.0)
var default_poly_vertex_2: Vector2 = Vector2(132.0, 125.0)

var default_poly_pos: Vector2 = Vector2(-270.0, -235.0)

var button_scale: float = 1.12
var poly_tw: Tween

func _ready() -> void:
	get_tree().paused = false
	GameManager.ui.hide()
	GameManager.pause_screen.hide()

func _process(delta) -> void:
	star.rotation_degrees += 48 * delta
	if star.rotation_degrees >= 360:
		star.rotation_degrees = 0

func change_poly_position(value: Vector2, vertex_index: int) -> void:
	var vertices: PackedVector2Array = selector_poly.polygon
	vertices[vertex_index] = value
	
	selector_poly.polygon = vertices

func mouse_entered(source: Node, index: int = 0) -> void:
	var tw: Tween = get_tree().create_tween()
	tw.tween_property(source, "position:x", 310.0, 0.1)
	
	var poly_vertices: PackedVector2Array = selector_poly.polygon
	
	var old_poly_vector_1: Vector2 = poly_vertices[1]
	var new_poly_vector_1: Vector2 = Vector2(default_poly_vertex_1.x, default_poly_vertex_1.y + (100 * index))
	
	var old_poly_vector_2: Vector2 = poly_vertices[2]
	var new_poly_vector_2: Vector2 = Vector2(default_poly_vertex_2.x, default_poly_vertex_2.y + (100 * index))
	
	if poly_tw: 
		if poly_tw.is_valid():
			poly_tw.kill()
	
	poly_tw = get_tree().create_tween()
	
	poly_tw.tween_method(change_poly_position.bind(1), old_poly_vector_1, new_poly_vector_1, 0.2)
	poly_tw.parallel()
	poly_tw.tween_method(change_poly_position.bind(2), old_poly_vector_2, new_poly_vector_2, 0.2)

func mouse_exited(source) -> void:
	var tw: Tween = get_tree().create_tween()
	tw.tween_property(source, "position:x", 280.0, 0.1)
	
	if start_menu.visible: return
	
	var poly_vertices: PackedVector2Array = selector_poly.polygon
	
	var old_poly_vector_1: Vector2 = poly_vertices[1]
	var old_poly_vector_2: Vector2 = poly_vertices[2]
	
	if poly_tw or poly_tw.is_valid():
		poly_tw.kill()
		
	poly_tw = get_tree().create_tween()
	
	poly_tw.tween_method(change_poly_position.bind(1), old_poly_vector_1, default_poly_pos, 0.2)
	poly_tw.parallel()
	poly_tw.tween_method(change_poly_position.bind(2), old_poly_vector_2, default_poly_pos, 0.2)

func mouse_pressed(source) -> void:
	var tw: Tween = get_tree().create_tween()
	tw.tween_property(source, "scale", Vector2(button_scale * 0.9, button_scale * 0.9), 0.04)
	tw.tween_property(source, "scale", Vector2(1, 1), 0.04)

func _on_start_pressed() -> void:
	main_menu.hide()
	start_menu.show()
	
	animation.play("start_menu")

func _on_settings_pressed() -> void:
	settings_screen.show()
	settings_screen.animation.play("open")
	animation.play("settings_screen")
	main_menu.hide()

func _on_exit_pressed() -> void:
	pass 

func _on_new_pressed() -> void:
	GameManager.SEED = int(seed_label.text) if int(seed_label.text.length() >= 0) else 232421
	
	SceneChanger.change_scene("world")
	# SceneChanger.change_scene("intro_screen")

func _on_continue_pressed() -> void:
	SaveManager.load_progress()
	
	SceneChanger.change_scene("world")

func _on_return_pressed() -> void:
	main_menu.show()
	start_menu.hide()
	
	animation.play_backwards("start_menu")

func _on_settings_exit_pressed() -> void:
	settings_screen.animation.play_backwards("open")
	animation.play_backwards("settings_screen")
	main_menu.show()
	
	await settings_screen.animation.animation_finished
	settings_screen.hide()

func _settings_exit_mouse_entered() -> void:
	var tw: Tween = get_tree().create_tween()
	tw.tween_property(settings_exit, "scale", Vector2(1.2, 1.2), 0.1)

func _settings_exit_mouse_exited() -> void:
	var tw: Tween = get_tree().create_tween()
	tw.tween_property(settings_exit, "scale", Vector2(1, 1), 0.1)
