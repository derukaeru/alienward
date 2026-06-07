class_name DoubleDoor extends Area3D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body) -> void:
	if body is Player or body is NPC or body is Patient:
		anim.play("open")


func _on_body_exited(body):
	if body is Player or body is NPC or body is Patient:
		anim.play_backwards("open")
