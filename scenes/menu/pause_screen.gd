@tool
extends Control

@onready var resume_btn: Button = $VBoxContainer/resume
@onready var settings_btn: Button = $VBoxContainer/settings
@onready var exit_btn: Button = $VBoxContainer/exit

func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
	Util.mouse_captured()

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	pass # Replace with function body.
