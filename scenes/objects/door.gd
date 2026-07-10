class_name Door extends Area3D

@onready var animation: AnimationPlayer = $AnimationPlayer

var bodies: Array = []

func _on_body_entered(body) -> void:
	if body is Player or body is NPC or body is Patient:
		if not animation.is_playing() and bodies.is_empty():
			animation.play("open")
		else:
			await animation.animation_finished
			animation.play("open")
		
		bodies.append(body)

func _on_body_exited(body) -> void:
	if body is Player or body is NPC or body is Patient:
		_remove_body(body)

func _remove_body(body: Node) -> void:
	if bodies.has(body):
		bodies.erase(body)

	if bodies.is_empty() and not animation.is_playing():
		animation.play_backwards("open")

func _physics_process(_delta: float) -> void:
	if bodies.is_empty():
		return

	var actual := get_overlapping_bodies()
	var stale := bodies.filter(func(b): return not actual.has(b))

	for b in stale:
		_remove_body(b)
