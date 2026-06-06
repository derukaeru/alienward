class_name InteractableComponent extends Area3D
signal interacted()

@export var tooltip_text: String = ""
@export var pickupable: bool = false
@export var internal_name: String = ""

func _ready() -> void:
	input_ray_pickable = true

func interact() -> void:
	interacted.emit()
