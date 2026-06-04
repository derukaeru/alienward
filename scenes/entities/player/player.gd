extends CharacterBody3D

@export var speed: float = 6.8
@export var gravity: float = 9.8

@onready var camera_mount: Node3D = $CameraMount
@onready var camera: Camera3D = $CameraMount/Camera3D
@onready var raycast: RayCast3D = $CameraMount/Camera3D/RayCast3D

# ui stuff
@onready var ui_layer: CanvasLayer = $CameraMount/Camera3D/ui

@onready var body_ui: Control = $CameraMount/Camera3D/ui/body
@onready var held_item_container: Control = $CameraMount/Camera3D/ui/body/held_item
@onready var fps_label: Label = $CameraMount/Camera3D/ui/fps
@onready var tooltip: Label = $CameraMount/Camera3D/ui/tooltip

var ui_lag_offset: Vector2 = Vector2.ZERO
var ui_lag_target: Vector2 = Vector2.ZERO
const UI_LAG_STRENGTH: float = 56.0
const UI_LAG_SPEED: float = 10.0   

const TILT_STRAFE_AMOUNT: float = 1.8
const TILT_LOOK_AMOUNT: float = 1.5
const TILT_RETURN_SPEED: float = 4.0

var tilt_target : float = 0.0
var mouse_sensitivity: float = 0.006
var can_move := true

const ITEMS_ID: Dictionary = {
	clipboard = "clipboard",
	baby = "baby_sprite",
	swab = "swab_sprite"
}

var held_item_id: String = ""
var held_item: InteractableComponent = null
var held_swab_id: int = -1

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_held_item("clipboard")

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
			if held_item_id == ITEMS_ID.baby: 
				speed_debuff = 0.84
				
			velocity.x = direction.x * speed * speed_debuff
			velocity.z = direction.z * speed * speed_debuff
			
			held_item_container.get_node("AnimationPlayer").play("bob")
			held_item_container.get_node("AnimationPlayer").play("bob")
		else:
			velocity.x = 0
			velocity.z = 0
			
			if held_item_container.get_node("AnimationPlayer").current_animation == "bob":
				held_item_container.get_node("AnimationPlayer").animation_finished.connect(func(_a): held_item_container.get_node("AnimationPlayer").play("RESET"), CONNECT_ONE_SHOT)
	
	move_and_slide()
	
	tilt_target += -input.x * TILT_STRAFE_AMOUNT * delta * 10
	
	tilt_target = clamp(tilt_target, -TILT_STRAFE_AMOUNT - TILT_LOOK_AMOUNT, TILT_STRAFE_AMOUNT + TILT_LOOK_AMOUNT)
	tilt_target = lerp(tilt_target, 0.0, TILT_RETURN_SPEED * delta)

	camera.rotation_degrees.z = tilt_target

func _process(delta) -> void:
	ui_lag_target = ui_lag_target.lerp(Vector2.ZERO, UI_LAG_SPEED * delta)
	ui_lag_offset = ui_lag_offset.lerp(ui_lag_target, UI_LAG_SPEED * delta)
	
	ui_lag_offset = ui_lag_offset.clamp(Vector2(-30, -20), Vector2(30, 20))
	body_ui.position = ui_lag_offset
	
	fps_label.text = "%d" % Engine.get_frames_per_second()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera.global_rotation.x -= event.relative.y * mouse_sensitivity
		camera.global_rotation.x = clamp(camera.global_rotation.x, -1.3, 1)
		camera.global_rotation.y -= event.relative.x * mouse_sensitivity
		
		# tilt_target += -event.relative.x * mouse_sensitivity * TILT_LOOK_AMOUNT
		
		ui_lag_target.x -= event.relative.x * mouse_sensitivity * UI_LAG_STRENGTH
		ui_lag_target.y -= event.relative.y * mouse_sensitivity * UI_LAG_STRENGTH

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
		if hit.pickupable:
			pick_up(hit)
			return
		else:
			hit.interact()
		
		# drop items
		if held_item:
			drop_item(hit)

func pick_up(item: InteractableComponent) -> void:
	if held_item_id == ITEMS_ID.swab:
		drop_item(null)
	if held_item_id == ITEMS_ID.baby:
		return
	
	held_item = item
	set_held_item(ITEMS_ID[item.internal_name])
	
	item.hide()
	item.global_position = Vector3.ZERO
	item.set_collision_layer_value(1, false)

func drop_item(hit: InteractableComponent) -> void:
	match held_item_id:
		ITEMS_ID.baby:
			if hit is Incubator:
				held_item.global_position = hit.global_position + Vector3(0.0, 0.8, 0.0)
				held_item.set_collision_layer_value(1, true)
				
				held_item.show()
				held_item = null
				
				set_held_item("clipboard")
		ITEMS_ID.swab:
			if (hit is InteractableComponent and hit.name == "scanner") or hit == null:
				held_item.global_position = global_position + Vector3.ZERO
				held_item.set_collision_layer_value(1, true)
				
				held_item.show()
				held_item = null
				
				set_held_item("clipboard")

func set_held_item(sprite_name: String) -> void:
	if held_item_id == ITEMS_ID.swab:
		held_swab_id = -1
		
	held_item_id = sprite_name
	
	var held_item_sprite: TextureRect = TextureRect.new()
	held_item_sprite.texture = load(Registry.UID[sprite_name])
	
	for entry in held_item_container.get_children():
		if entry is not AnimationPlayer:
			entry.queue_free()
	
	held_item_container.add_child(held_item_sprite)
