extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if Input.is_action_just_pressed("ui_cancel") and player.ui_layer.shop_open:
		leave()

func leave() -> void:
	Util.mouse_captured()
	animation.play_backwards("pop")
	await animation.animation_finished
	
	hide()
	EventBus.close_shop.emit()

func buy_base_item(item_name: String) -> void:
	EventBus.shop_buy_item.emit(item_name)
