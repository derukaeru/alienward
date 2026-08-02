extends Control

func _ready() -> void:
	get_tree().create_timer(1.6).timeout.connect(queue_free)

func _process(delta) -> void:
	global_position.y -= delta * 24
