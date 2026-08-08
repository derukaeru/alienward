extends Control

@onready var resume_btn: Button = $resume
@onready var settings_btn: Button = $settings
@onready var exit_btn: Button = $exit

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var settings_screen: Control = $settings_screen
@onready var settings_exit: Button = $settings_exit

func mouse_entered(source: Node) -> void:
	var tw: Tween = get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(source, "position:x", 300.0, 0.1)

func mouse_exited(source: Node) -> void:
	var tw: Tween = get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(source, "position:x", 276.0, 0.1)

func mouse_pressed(_source: Node) -> void:
	pass
	
func _on_resume_pressed() -> void:
	animation.play_backwards("toggle")
	await animation.animation_finished
	
	hide()
	Util.mouse_captured()
	
	get_tree().paused = false

func _on_settings_pressed() -> void:
	settings_screen.show()
	settings_exit.show()
	
	settings_screen.animation.play("open")
	animation.play("settings_screen")
	
	settings_screen.update_data()
	

func _on_exit_pressed() -> void:
	SceneChanger.change_scene("title_screen")
	GameManager.ui.hide()
	GameManager.reset_day()

func _settings_exit_mouse_entered() -> void:
	var tw: Tween = get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(settings_exit, "scale", Vector2(1.2, 1.2), 0.1)

func _settings_exit_mouse_exited() -> void:
	var tw: Tween = get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(settings_exit, "scale", Vector2(1, 1), 0.1)

func _settings_exit_pressed() -> void:
	settings_screen.animation.play_backwards("open")
	animation.play_backwards("settings_screen")
	
	await settings_screen.animation.animation_finished
	settings_screen.hide()
	settings_exit.hide()
