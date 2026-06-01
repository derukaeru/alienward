extends CharacterBody3D

@export var speed: float = 6.8
@export var gravity: float = 9.8

@onready var camera_mount: Node3D = $CameraMount
@onready var camera: Camera3D = $CameraMount/Camera3D
@onready var clipboard: TextureRect = $CameraMount/Camera3D/ui/clipboard
@onready var fps_label: Label = $CameraMount/Camera3D/ui/fps
@onready var raycast: RayCast3D = $CameraMount/Camera3D/RayCast3D
@onready var baby: TextureRect = $CameraMount/Camera3D/ui/baby
@onready var tooltip: Label = $CameraMount/Camera3D/ui/tooltip


const TILT_STRAFE_AMOUNT: float = 3.4
const TILT_LOOK_AMOUNT: float = 1.5
const TILT_RETURN_SPEED: float = 4.0

var tilt_target : float = 0.0
var mouse_sensitivity: float = 0.006
var can_move := true

var held_baby: Baby = null

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input = Vector2(Input.get_axis("left", "right"), Input.get_axis("forward", "backward"))
	if can_move:
		var direction = (camera.global_transform.basis * Vector3(input.x, 0, input.y)).normalized()
		direction.y = 0 
		
		if direction.length() > 0.1:
			direction = direction.normalized()
			
			var speed_debuff: float = 1.0
			if held_baby: 
				speed_debuff = 0.84
				
			velocity.x = direction.x * speed * speed_debuff
			velocity.z = direction.z * speed * speed_debuff
			
			clipboard.get_node("AnimationPlayer").play("bob")
			baby.get_node("AnimationPlayer").play("bob")
		else:
			velocity.x = 0
			velocity.z = 0
			
			if clipboard.get_node("AnimationPlayer").current_animation == "bob":
				clipboard.get_node("AnimationPlayer").animation_finished.connect(func(_a): clipboard.get_node("AnimationPlayer").play("RESET"), CONNECT_ONE_SHOT)
			if baby.get_node("AnimationPlayer").current_animation == "bob":
				baby.get_node("AnimationPlayer").animation_finished.connect(func(_a): clipboard.get_node("AnimationPlayer").play("RESET"), CONNECT_ONE_SHOT)
	
	move_and_slide()
	
	tilt_target += -input.x * TILT_STRAFE_AMOUNT * delta * 10
	
	tilt_target = clamp(tilt_target, -TILT_STRAFE_AMOUNT - TILT_LOOK_AMOUNT, TILT_STRAFE_AMOUNT + TILT_LOOK_AMOUNT)
	tilt_target = lerp(tilt_target, 0.0, TILT_RETURN_SPEED * delta)

	camera.rotation_degrees.z = tilt_target

func _process(_delta) -> void:
	fps_label.text = "%d" % Engine.get_frames_per_second()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera.global_rotation.x -= event.relative.y * mouse_sensitivity
		camera.global_rotation.x = clamp(camera.global_rotation.x, -1, 0.7)
		camera.global_rotation.y -= event.relative.x * mouse_sensitivity
		
		# Tilt from looking left/right
		tilt_target += -event.relative.x * mouse_sensitivity * TILT_LOOK_AMOUNT


func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pass

	if raycast.is_colliding(): 
		if raycast.get_collider() is InteractableComponent:
			tooltip.text = raycast.get_collider().tooltip_text
		
		if event.is_action_pressed("interact"):
			_try_interact()
	else:
		tooltip.text = ""
	
func _try_interact() -> void:
	var hit = raycast.get_collider()
	if hit is InteractableComponent:
		hit.interact()
	
	if hit is Incubator and held_baby != null:
		camera.remove_child(held_baby)
		Util.get_group_node("entities_container").add_child(held_baby)
		
		held_baby.global_position = hit.global_position + Vector3(0, .8, 0)
		held_baby.set_collision_layer_value(1, true)
		held_baby.show()
		held_baby = null
		
		clipboard.show()
		baby.hide()
