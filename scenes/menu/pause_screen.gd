extends Control

func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
	Util.mouse_captured()

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	pass # Replace with function body.
