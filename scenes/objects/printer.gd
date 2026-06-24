extends InteractableComponent

@onready var animation: AnimationPlayer = $ModelContainer/AnimationPlayer

func print_ultrasound() -> void:
	animation.play("print")
	await animation.animation_finished

func interact() -> void:
	animation.play("RESET")
