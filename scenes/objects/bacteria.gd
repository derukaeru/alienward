class_name Bacteria extends Control

var move_timer: float = 1.2
var initial_position: Vector2

func _ready() -> void:
	initial_position = global_position
	
