class_name Incubator extends InteractableComponent
@onready var anim: AnimationPlayer = $ModelContainer/AnimationPlayer

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.incubator

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == player.ITEMS_ID.baby:
		show_tooltip_text = true
	else:
		show_tooltip_text = false

func interact() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == player.ITEMS_ID.baby:
		anim.play("bob")
		player.held_item.global_position = global_position + Vector3(0.0, 0.8, 0.0)
		player.held_item.set_collision_layer_value(1, true)
		
		player.held_item.show()
		player.held_item = null
		
		player.set_held_item_sprite("clipboard")
