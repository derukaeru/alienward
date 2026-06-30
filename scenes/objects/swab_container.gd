class_name SwabContainer extends InteractableComponent

@onready var animation: AnimationPlayer = $ModelContainer/AnimationPlayer

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.swab_container

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == ITEMS.IDS.swab:
		show_tooltip_text = false
	else:
		show_tooltip_text = true

func _on_interacted() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id != ITEMS.IDS.clipboard: return
	
	animation.play("pop")
	
	var _swab: Item = load(Registry.UID["swab"]).instantiate()
	Util.add_entity_to_container(_swab)
	
	_swab.name = "swab"
	player.pick_up(_swab)
