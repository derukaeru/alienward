extends Area3D

var duration: int = 20
var bodies: Array = []

func _ready() -> void:
	get_tree().create_timer(duration).timeout.connect(end)
	pass

func _on_body_entered(body) -> void:
	if body is Player:
		bodies.append(body)
		body.hallucinogen = true

func _on_body_exited(body) -> void:
	if body is Player:
		_remove_body(body)

func _remove_body(body: Node) -> void:
	if bodies.has(body):
		bodies.erase(body)
		give_effect(body)

func _physics_process(_delta: float) -> void:
	if bodies.is_empty():
		return

	var actual := get_overlapping_bodies()
	var stale := bodies.filter(func(b): return not actual.has(b))

	for b in stale:
		_remove_body(b)
		if b is Player:
			give_effect(b)

func give_effect(body: Player) -> void:
	body.hallucinogen_timer = 8.0
	body.hallucinogen = true
