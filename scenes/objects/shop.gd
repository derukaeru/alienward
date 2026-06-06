extends Node3D

@onready var interactable: InteractableComponent = $InteractableComponent

func _ready() -> void:
	interactable.tooltip_text = Lang.TOOLTIPS.shop

func _on_interactable_component_interacted() -> void:
	if GameManager.shop_open: return
	
	GameManager.open_shop_screen()
	Util.mouse_visible()
