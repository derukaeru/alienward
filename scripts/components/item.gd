class_name Item extends Area3D
signal interacted()

@export var show_tooltip_text: bool = true
@export var pickupable: bool = true
@export var internal_name: String = ""

func _ready() -> void:
	input_ray_pickable = true

func interact() -> void:
	interacted.emit()
