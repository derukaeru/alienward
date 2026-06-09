extends Control

func leave() -> void:
	hide()
	GameManager.shop_open = false
	
	var player: Player = Util.get_player()
	if not player: return
	
	player.can_move = true
	Util.mouse_captured()
	

func _process(_delta) -> void:
	if Input.is_action_just_pressed("ui_cancel") and GameManager.shop_open:
		leave()
