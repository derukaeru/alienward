extends Node3D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	EventBus.open_curtain.connect(open)
	EventBus.close_curtain.connect(close)

func open(index: int) -> void:
	if index == name.trim_prefix("curtain_").to_int():
		animation.play_backwards("fold")

func close(index: int) -> void:
	if index == name.trim_prefix("curtain_").to_int():
		animation.play("fold")
