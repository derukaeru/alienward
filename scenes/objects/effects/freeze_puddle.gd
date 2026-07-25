class_name FreezePuddle extends Area3D

var duration: float = 20.0
var bodies: Array = []
var baby: Baby

func _ready() -> void:
	get_tree().create_timer(duration).timeout.connect(end)
	global_position.y = 0.0

func _on_body_entered(body) -> void:
	if body is Player:
		bodies.append(body)
		give_effect(body)

func _physics_process(_delta: float) -> void:
	if bodies.is_empty():
		return

	var actual := get_overlapping_bodies()
	for body in actual:
		if body is Player:
			give_effect(body)

func give_effect(body: Player) -> void:
	body.hypothermia_timer = 8.0
	body.hypothermia = true

func end() -> void:
	baby.state = Baby.STATES.SLEEPING
	baby.set_effect_activation()
	
	queue_free()
