class_name DeliveryTable extends InteractableComponent

var held_baby: Baby

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.delivery_table

func interact() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if held_baby:
		player.pick_up(held_baby)

func change_tooltip() -> void:
	if held_baby:
		tooltip_text = Lang.TOOLTIPS.delivery_table_baby
	else:
		tooltip_text = Lang.TOOLTIPS.delivery_table
