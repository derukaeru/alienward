extends Control

func leave() -> void:
	hide()
	GameManager.shop_open = false
	
	var player: Player = Util.get_player()
	if not player: return
	
	player.can_move = true
	Util.mouse_captured()
	

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if Input.is_action_just_pressed("ui_cancel") and player.ui_layer.shop_open:
		leave()
