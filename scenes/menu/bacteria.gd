class_name Bacteria extends Control

var move_timer: float = 1.2
var initial_position: Vector2

var identified: bool = false
var index: int = GameManager.UNASSIGNED

func _ready() -> void:
	initial_position = global_position

func pick_bacteria() -> void:
	if not identified:
		EventBus.identify_bacteria.emit(self)
	else:
		EventBus.show_dna.emit(index)
