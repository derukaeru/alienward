extends InteractableComponent

@onready var animation: AnimationPlayer = $ModelContainer/AnimationPlayer
@onready var base_antidote_sprite: Node3D = $BaseAntidoteSprite

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
		base_antidote_sprite.texture = load(Registry.UID[base_antidote_name])

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

	var antidote_instance: Antidote = load(Registry.UID.antidote_instance).instantiate()
	antidote_instance.data = data

	base_antidote_sprite.texture = null
	Util.add_entity_to_container(antidote_instance)
	player.pick_up(antidote_instance)

func _process(_delta: float) -> void:
	base_antidote_sprite.rotation.y += 0.01
	if base_antidote_sprite.rotation.y > 360:
		base_antidote_sprite.rotation.y = 0
