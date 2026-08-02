extends Label

@onready var animation: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	animation.play("up")
	await animation.animation_finished
	queue_free()
