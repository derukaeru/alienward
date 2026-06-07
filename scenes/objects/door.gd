class_name Door extends Area3D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body) -> void:
	if body is Player or body is NPC or body is Patient:
		animation.play("open")

func _on_body_exited(body) -> void:
	if body is Player or body is NPC or body is Patient:
		animation.play_backwards("open")
