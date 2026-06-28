extends InteractableComponent

@onready var animation: AnimationPlayer = $ModelContainer/AnimationPlayer
var base_antidote_name: String

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.antidote_stand
	EventBus.generate_antidote.connect(generate_antidote)

func interact() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item is BaseAntidoteItem:
		base_antidote_name = player.held_item.internal_name
		EventBus.update_base_antidote_item_name.emit(base_antidote_name)
		player.remove_held_item()
		
		animation.play("pop")
	else:
		if player.ui_layer.antidote_open: return
		
		animation.play("pop")
		EventBus.open_antidote_stand.emit()

func generate_antidote(data: Dictionary = {}) -> void:
	if not data: return
	
	var player: Player = Util.get_player()
	if not player: return
	
	var antidote_instance: Antidote = load(Registry.UID["antidote_instance"]).instantiate()
	antidote_instance.data = data
	
	var entities_container: Node3D = Util.get_group_node("entities_container")
	entities_container.add_child(antidote_instance)
	
	player.pick_up(antidote_instance)
