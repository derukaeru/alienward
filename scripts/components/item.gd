class_name Item extends Area3D
signal interacted

@warning_ignore("unused_signal")
signal picked_up
@warning_ignore("unused_signal")
signal dropped

@export var show_tooltip_text: bool = true
@export var tooltip_text: String = ""
@export var pickupable: bool = true
@export var internal_name: String = ""

func _ready() -> void:
	input_ray_pickable = true

func interact() -> void:
	interacted.emit()
