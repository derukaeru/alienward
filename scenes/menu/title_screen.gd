extends Control

@onready var main_menu: Control = $main_menu
@onready var start_menu: Control = $start_menu

var button_scale: float = 1.25

func mouse_entered(source) -> void:
	var tw: Tween = get_tree().create_tween()
	tw.tween_property(source, "scale", Vector2(button_scale, button_scale), 0.1)

func mouse_exited(source) -> void:
	var tw: Tween = get_tree().create_tween()
	tw.tween_property(source, "scale", Vector2(1, 1), 0.1)

func mouse_pressed(source) -> void:
	var tw: Tween = get_tree().create_tween()
	tw.tween_property(source, "scale", Vector2(button_scale * 0.9, button_scale * 0.9), 0.04)
	tw.tween_property(source, "scale", Vector2(button_scale, button_scale), 0.04)

func _on_start_pressed() -> void:
	main_menu.hide()
	start_menu.show()

func _on_settings_pressed() -> void:
	pass 

func _on_exit_pressed() -> void:
	pass 


func _on_new_pressed() -> void:
	GameManager.start_day(0)
	SceneChanger.change_scene("world")

func _on_continue_pressed() -> void:
	GameManager.start_day()
	SceneChanger.change_scene("world")

func _on_return_pressed() -> void:
	main_menu.show()
	start_menu.hide()
