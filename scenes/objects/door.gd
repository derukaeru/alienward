class_name Door extends Area3D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body) -> void:
	if body.is_in_group("player") or body.is_in_group("npc") or body.is_in_group("patient"):
		animation.play("open")

func _on_body_exited(body) -> void:
	if body.is_in_group("player") or body.is_in_group("npc") or body.is_in_group("patient"):
		animation.play_backwards("open")
