class_name Door extends Area3D

@onready var animation: AnimationPlayer = $AnimationPlayer

var bodies: Array = []

func _on_body_entered(body) -> void:
	if body is Player or body is NPC or body is Patient:
		if not animation.is_playing() and bodies.is_empty():
			animation.play("open")
		
		bodies.append(body)
		

func _on_body_exited(body) -> void:
	if body is Player or body is NPC or body is Patient:
		if bodies.has(body):
			bodies.erase(body)
			
		if bodies.is_empty():
			animation.play_backwards("open")
