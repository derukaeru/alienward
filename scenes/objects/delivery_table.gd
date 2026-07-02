class_name DeliveryTable extends InteractableComponent

var held_baby: Baby

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.delivery_table
	EventBus.deliver_child.connect(deliver_baby)

func interact() -> void:
	if held_baby:
		EventBus.pick_up_baby_from_delivery_table.emit(held_baby)

func change_tooltip() -> void:
	if held_baby:
		tooltip_text = Lang.TOOLTIPS.delivery_table_baby
	else:
		tooltip_text = Lang.TOOLTIPS.delivery_table

func deliver_baby(index: int, baby: Baby) -> void:
	if index == name.trim_prefix("delivery_table_").to_int():
		baby.delivery_table = self
		baby.is_in_delivery_table = true
		
		held_baby = baby
		change_tooltip()
		baby.global_position = global_position + Vector3(0.0, 1.8, 0.0)
