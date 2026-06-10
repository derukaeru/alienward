extends Control

func _on_leave_pressed() -> void:
	hide()
	
	var player: Player = Util.get_player()
	if not player: return
	
	player.ui_layer.microscope_open = false
	
	player.can_move = true
	Util.mouse_captured()
	
func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if Input.is_action_just_pressed("ui_cancel") and player.ui_layer.microscope_open:
		_on_leave_pressed()
