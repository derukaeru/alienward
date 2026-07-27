extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation.play("play_intro")
	#await animation.animation_finished
	SceneChanger.change_scene("world")
