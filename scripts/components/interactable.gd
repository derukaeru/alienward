class_name InteractableComponent extends Area3D
signal interacted(interactor)

func _ready():
	input_ray_pickable = true

func interact() -> void:
	interacted.emit()
