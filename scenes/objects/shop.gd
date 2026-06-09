extends Node3D

@onready var interactable: InteractableComponent = $InteractableComponent

func _ready() -> void:
	interactable.tooltip_text = Lang.TOOLTIPS.shop

func _on_interactable_component_interacted() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.ui_layer.shop_open: return
	
	player.ui_layer.open_shop_screen()
	Util.mouse_visible()
