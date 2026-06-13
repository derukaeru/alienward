class_name Dirt extends InteractableComponent

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite3D = $Sprite3D

func _ready() -> void:
	animation.play("show")
	sprite.rotation.y = randf_range(0, 360)
	
func interact() -> void:
	pass
