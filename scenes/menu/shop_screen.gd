extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var notification_container: Control = $notification_container

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if Input.is_action_just_pressed("ui_cancel") and player.ui.shop_open:
		leave()

func leave() -> void:
	Util.mouse_captured()
	animation.play_backwards("pop")
	await animation.animation_finished
	
	hide()
	EventBus.close_shop.emit()

func buy_base_item(item_name: String) -> void:
	EventBus.shop_buy_item.emit(item_name)
	new_notification()

func new_notification() -> void:
	var buy_notification: Control = load(Registry.UID.shop_notification).instantiate()
	notification_container.add_child(buy_notification)
