class_name InteractableComponent extends Area3D
signal interacted()

@export var show_tooltip_text: bool = false
@export var tooltip_text: String = ""

func _ready() -> void:
	input_ray_pickable = true

func interact() -> void:
	interacted.emit()
