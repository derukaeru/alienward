class_name DeliveryTable extends InteractableComponent

var held_baby: Baby

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.delivery_table

func interact() -> void:
	if held_baby:
		EventBus.pick_up_baby_from_delivery_table.emit(held_baby)

func change_tooltip() -> void:
	if held_baby:
		tooltip_text = Lang.TOOLTIPS.delivery_table_baby
	else:
		tooltip_text = Lang.TOOLTIPS.delivery_table
