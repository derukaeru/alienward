class_name Player extends CharacterBody3D

@export var speed: float = 6.8
@export var gravity: float = 9.8

@onready var camera_mount: Node3D = $CameraMount
@onready var camera: Camera3D = $CameraMount/Camera3D
@onready var raycast: RayCast3D = $CameraMount/Camera3D/RayCast3D

@onready var ui_layer: CanvasLayer = $CameraMount/Camera3D/ui

var ui_lag_offset: Vector2 = Vector2.ZERO
var ui_lag_target: Vector2 = Vector2.ZERO
const UI_LAG_STRENGTH: float = 56.0
const UI_LAG_SPEED: float = 10.0   

const TILT_STRAFE_AMOUNT: float = 1.8
const TILT_LOOK_AMOUNT: float = 1.5
const TILT_RETURN_SPEED: float = 4.0

var tilt_target: float = 0.0
var mouse_sensitivity: float = 0.006
var can_move: bool = true

const ITEMS_ID: Dictionary = {
	clipboard = "clipboard",
	baby = "baby_sprite",
	swab = "swab_sprite",
	swab_used = "swab_used"
}

var held_item_id: String = ""
var held_item: InteractableComponent = null

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_held_item_sprite("clipboard")
	
	ui_layer.held_item.get_node("AnimationPlayer").animation_finished.connect(
		func(_a): 
			ui_layer.held_item.get_node("AnimationPlayer").play("RESET"), 
			CONNECT_ONE_SHOT
	)

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
			
			ui_layer.held_item.get_node("AnimationPlayer").play("bob")
		else:
			velocity.x = 0
			velocity.z = 0
	
	move_and_slide()
	
	tilt_target += -input.x * TILT_STRAFE_AMOUNT * delta * 10
	
	tilt_target = clamp(tilt_target, -TILT_STRAFE_AMOUNT - TILT_LOOK_AMOUNT, TILT_STRAFE_AMOUNT + TILT_LOOK_AMOUNT)
	tilt_target = lerp(tilt_target, 0.0, TILT_RETURN_SPEED * delta)

	camera.rotation_degrees.z = tilt_target

func _process(delta) -> void:
	ui_lag_target = ui_lag_target.lerp(Vector2.ZERO, UI_LAG_SPEED * delta)
	ui_lag_offset = ui_lag_offset.lerp(ui_lag_target, UI_LAG_SPEED * delta)
	
	ui_lag_offset = ui_lag_offset.clamp(Vector2(-30, -20), Vector2(30, 20))
	ui_layer.body.position = ui_lag_offset
	
	ui_layer.fps.text = "%d" % Engine.get_frames_per_second()
	ui_layer.dirtiness.text = "Dirt: %d" % GameManager.dirtiness 

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
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and not GameManager.has_interacted:
			GameManager.has_interacted = true
			_try_interact()
	
	if raycast.is_colliding(): 
		var collider: Node = raycast.get_collider()
		if collider is InteractableComponent:
			if collider.show_tooltip_text:
				ui_layer.tooltip.text = raycast.get_collider().tooltip_text
	else:
		ui_layer.tooltip.text = ""
	
	if Input.is_action_just_pressed("drop"):
		drop_item(null)

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
		if item is Baby and held_item.baby_id == -1:
			held_item.baby_id = item.id
			
			held_item.internal_name = "swab_used"
			set_held_item_sprite(ITEMS_ID.swab_used)
			
			return
		drop_item(null)
	if held_item_id == ITEMS_ID.baby:
		return
	
	# TODO HERE
	if held_item_id == "ITEMS FOR BABIES":
		pass
		
	held_item = item
	set_held_item_sprite(ITEMS_ID[item.internal_name])
	
	item.hide()
	item.global_position = Vector3.ZERO
	item.set_collision_layer_value(1, false)

func drop_item(hit: InteractableComponent) -> void:
	match held_item_id:
		ITEMS_ID.swab:
			if hit == null:
				held_item.global_position = global_position + Vector3.ZERO
				held_item.set_collision_layer_value(1, true)
				
				held_item.show()
				held_item = null
				
				set_held_item_sprite("clipboard")
		ITEMS_ID.swab_used:
			if hit == null:
				held_item.global_position = global_position + Vector3.ZERO
				held_item.set_collision_layer_value(1, true)
				
				held_item.show()
				held_item = null
				
				set_held_item_sprite("clipboard")

func set_held_item_sprite(sprite_name: String) -> void:
	held_item_id = sprite_name
	
	var held_item_sprite: TextureRect = TextureRect.new()
	held_item_sprite.texture = load(Registry.UID[sprite_name])
	
	for entry in ui_layer.held_item.get_children():
		if entry is not AnimationPlayer:
			entry.queue_free()
	
	ui_layer.held_item.add_child(held_item_sprite)
	ui_layer.held_item.get_node("AnimationPlayer").play("get_item")

func remove_held_item() -> void:
	held_item.queue_free()
	held_item = null
	
	set_held_item_sprite("clipboard")
