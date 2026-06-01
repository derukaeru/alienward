class_name InteractableComponent extends Area3D
signal interacted(interactor)

@export var tooltip_text: String = ""

func _ready() -> void:
	input_ray_pickable = true

func interact() -> void:
	interacted.emit()
