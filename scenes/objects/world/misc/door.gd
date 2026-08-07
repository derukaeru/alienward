class_name Door extends Area3D

@onready var door: StaticBody3D = $door_collision

var door_tween: Tween
var bodies: Array = []

func _on_body_entered(body) -> void:
	if body is Player or body is NPC or body is Patient:
		if door_tween and door_tween.is_valid():
			door_tween.kill()
		
		door_tween = get_tree().create_tween()
		door_tween.tween_property(door, "position:x", 2.39, 0.2)
		
		bodies.append(body)

func _on_body_exited(body) -> void:
	if body is Player or body is NPC or body is Patient:
		_remove_body(body)

func _remove_body(body: Node) -> void:
	if bodies.has(body):
		bodies.erase(body)
	
	if bodies.is_empty():
		if door_tween and door_tween.is_valid():
			door_tween.kill()
		
		door_tween = get_tree().create_tween()
		door_tween.tween_property(door, "position:x", 0.0, 0.2)

func _physics_process(_delta: float) -> void:
	if bodies.is_empty():
		return

	var actual := get_overlapping_bodies()
	var stale := bodies.filter(func(b): return not actual.has(b))

	for b in stale:
		_remove_body(b)
