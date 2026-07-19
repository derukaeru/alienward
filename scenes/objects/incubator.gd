class_name Incubator extends InteractableComponent
signal changed_temperature(temp: float)

@onready var anim: AnimationPlayer = $ModelContainer/AnimationPlayer

var incubated_baby: Baby
var changing_temp: bool = false
var temperature: float = 1.0

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.incubator

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return

	if player.held_item_id == ITEMS.IDS.baby:
		if incubated_baby:
			tooltip_text = Lang.TOOLTIPS.incubator_occupied
		else:
			tooltip_text = Lang.TOOLTIPS.incubator
	else:
		tooltip_text = Lang.TOOLTIPS.incubator_normal

func interact() -> void:
	if incubated_baby:
		if incubated_baby.current_temperature != temperature:
			EventBus.open_incubator_screen.emit(self)
		else:
			incubate_baby()
	else:
		incubate_baby()

func incubate_baby(baby: Baby = null) -> void:
	if not baby:
		var player: Player = Util.get_player()
		if not player: return

		if not player.held_item_id == ITEMS.IDS.baby: return
		if incubated_baby:
			player.ui_layer.show_warning(Lang.WARNINGS.incubator_occupied)
			return

		anim.play("bob")

		player.held_item.held = false
		player.held_item.show()
		incubated_baby = player.held_item

		incubated_baby.global_position = global_position + Vector3(0.0, 0.7, 0.0)
		incubated_baby.set_collision_layer_value(1, true)

		player.held_item.incubator = self
		player.held_item = null

		player.set_held_item_sprite("clipboard")
		EventBus.incubated_child.emit(incubated_baby.patient_id)
	else:
		if incubated_baby: return

		baby.set_collision_layer_value(1, true)
		baby.Vector3(0.0, 0.8, 0.0)
		baby.show()
		incubated_baby = baby

		baby.incubator = self
		baby.is_in_incubator = true

func baby_temperature_changed(temp: float) -> void:
	if not incubated_baby: return

	temperature = temp
	# TODO:change the temperature display

func change_temperature(temp: float, incubator: Incubator) -> void:
	if not incubator == self: return
	temperature = temp
