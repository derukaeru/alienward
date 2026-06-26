extends InteractableComponent

@onready var animation: AnimationPlayer = $ModelContainer/AnimationPlayer
var base_antidote_name: String

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.antidote_stand

func interact() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if not player.held_item is BaseAntidoteItem:
		if player.ui_layer.antidote_open: return
		player.ui_layer.antidote_screen.opened()
		
		animation.play("pop")
		player.ui_layer.open_antidote_screen()
	elif player.held_item is BaseAntidoteItem:
		base_antidote_name = player.held_item.internal_name
		player.remove_held_item()
		
		animation.play("pop")
