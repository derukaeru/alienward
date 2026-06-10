extends Control

@onready var resume_btn: Button = $resume
@onready var settings_btn: Button = $settings
@onready var exit_btn: Button = $exit

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
	
func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
	Util.mouse_captured()

func _on_settings_pressed() -> void:
	pass

func _on_exit_pressed() -> void:
	pass
