class_name Incubator extends InteractableComponent
@onready var anim: AnimationPlayer = $ModelContainer/AnimationPlayer

var incubated_baby: Baby

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
		EventBus.incubated_child.emit(incubated_baby.id)
	else:
		if incubated_baby: return
		
		baby.set_collision_layer_value(1, true)
		baby.Vector3(0.0, 0.8, 0.0)
		baby.show()
		incubated_baby = baby
		
		baby.incubator = self
		baby.is_in_incubator = true
