extends Node3D

@onready var interactable: InteractableComponent = $InteractableComponent
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	interactable.tooltip_text = Lang.TOOLTIPS.shop

func _on_interactable_component_interacted() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.ui_layer.shop_open: return
	
	animation.play("pop")
	player.ui_layer.open_shop_screen()
