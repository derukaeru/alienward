class_name DirectionalSprite extends AnimatedSprite3D

var current_animation: int = 0
var animations = null

var camera: Camera3D

func _ready() -> void:
	animations = sprite_frames.get_animation_names()
	set_billboard_mode(BaseMaterial3D.BILLBOARD_FIXED_Y)
	camera = get_viewport().get_camera_3d()

func _process(_delta) -> void:
	if not camera:
		return

	var player_forward: Vector3 = -camera.global_transform.basis.z
	var forward: Vector3 = global_transform.basis.z
	var left: Vector3 = global_transform.basis.x

	var left_dot: float = left.dot(player_forward)
	var forward_dot: float = forward.dot(player_forward)

	if left_dot > 0 and forward_dot < 0:
		current_animation = 0
	if left_dot < 0 and forward_dot > 0:
		current_animation = 1
	if left_dot < 0 and forward_dot < 0:
		current_animation = 2
	if left_dot > 0 and forward_dot > 0:
		current_animation = 3
	
	var _progress = get_frame_progress()
	if len(animations) > current_animation:
		play(animations[current_animation])
		set_frame_progress(_progress)
