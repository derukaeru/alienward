class_name Bacteria extends Control

var move_timer: float = 1.2
var initial_position: Vector2

var identified: bool = false
var index: int = GameManager.UNASSIGNED

func _ready() -> void:
	initial_position = global_position

func pick_bacteria() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	var microscope_screen: Control = player.ui_layer.microscope_screen
	
	if not identified:
		microscope_screen.identify_bacteria(self)
	else:
		microscope_screen.set_dna_color(index)
