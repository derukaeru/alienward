extends Node3D

@onready var animation: AnimationPlayer = $AnimationPlayer

func open() -> void:
	animation.play_backwards("fold")

func close() -> void:
	animation.play("fold")
