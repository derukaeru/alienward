extends Area3D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		animation.play("open")

func _on_body_exited(body) -> void:
	if body.is_in_group("player"):
		animation.play_backwards("open")
