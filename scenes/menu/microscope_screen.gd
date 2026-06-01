extends Control

func _on_leave_pressed() -> void:
	hide()
	
	Util.get_player().can_move = true
	Util.mouse_captured()
	
	GameManager.shop_open = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and GameManager.microscope_open:
		_on_leave_pressed()
