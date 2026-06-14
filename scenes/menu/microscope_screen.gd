extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer

func _on_leave_pressed() -> void:
	Util.mouse_captured()
	
	animation.play_backwards("pop")
	await animation.animation_finished
	
	hide()
	
	var player: Player = Util.get_player()
	if not player: return
	
	player.ui_layer.microscope_open = false
	player.can_move = true
	
func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if Input.is_action_just_pressed("ui_cancel") and player.ui_layer.microscope_open:
		_on_leave_pressed()
