extends Control

func _on_leave_pressed() -> void:
	hide()
	GameManager.microscope_open = false

	
	var player: Player = Util.get_player()
	if not player: return
	
	player.can_move = true
	Util.mouse_captured()
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_cancel") and GameManager.microscope_open:
		_on_leave_pressed()
