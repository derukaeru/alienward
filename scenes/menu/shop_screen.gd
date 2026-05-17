extends Control

func leave():
	GameManager.shop_open = false
	Util.mouse_captured()
	hide()
	
	Util.get_player().can_move = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and GameManager.shop_open:
		leave()
