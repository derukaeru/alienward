class_name Fumes extends Area3D

@onready var hallucinogen: GPUParticles3D = $hallucinogen

var duration: float = 20.0
var bodies: Array = []
var baby: Baby

func _ready() -> void:
	get_tree().create_timer(duration).timeout.connect(func(): hallucinogen.emitting = false)
	hallucinogen.finished.connect(end)

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
	body.hallucinogen_timer = 8.0
	body.hallucinogen = true

func end() -> void:
	if not baby: return
	
	baby.state = Baby.STATES.SLEEPING
	baby.set_effect_activation()
	
	queue_free()
