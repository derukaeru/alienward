class_name Player extends CharacterBody3D

var default_speed: float = 6.8
var speed: float = default_speed
@export var gravity: float = 9.8

@onready var camera_mount: Node3D = $CameraMount
@onready var camera: Camera3D = $CameraMount/Camera3D
@onready var raycast: RayCast3D = $CameraMount/Camera3D/RayCast3D

var ui: CanvasLayer

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

var held_item_id: String = ""
var held_item: Item = null

var hallucinogen: bool = false
var hallucinogen_timer: float = 0.0

var hypothermia: bool = false
var hypothermia_timer: float = 0.0

func _ready() -> void:
	var ui_layer: CanvasLayer = GameManager.get_ui()
	ui = ui_layer
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_held_item_sprite("clipboard")
	
	EventBus.pick_up_baby_from_delivery_table.connect(pick_up)
	EventBus.throw_item.connect(throw_item)
	
	EventBus.stop_player_movement.connect(stop_movement)
	EventBus.player_can_move.connect(set_movement)
	
	EventBus.day_ended.connect(func() -> void:
		can_move = false
		velocity = Vector3.ZERO
	)
	
	ui.held_item.get_node("AnimationPlayer").animation_finished.connect(
		func(_a) -> void:
			ui.held_item.get_node("AnimationPlayer").play("RESET"),
			CONNECT_ONE_SHOT
	)
	ui.hand.get_node("AnimationPlayer").animation_finished.connect(
		func(_a) -> void:
			ui.hand.get_node("AnimationPlayer").play("RESET"),
			CONNECT_ONE_SHOT
	)

	EventBus.clean_mop.connect(
		func() -> void:
			if held_item_id == ITEMS.IDS.mop:
				held_item.dirtiness = 0.0
				Util.add_subtitle(Lang.subtitles.cleaned_mop)
	)

func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input = Vector2(Input.get_axis("left", "right"), Input.get_axis("forward", "backward"))
	if hallucinogen:
		input = -input

	if can_move:
		var direction = (camera.global_transform.basis * Vector3(input.x, 0, input.y)).normalized()
		direction.y = 0
		
		if direction.length() > 0.1:
			direction = direction.normalized()
			
			var speed_debuff: float = 1.0
			if held_item_id == ITEMS.IDS.baby:
				speed_debuff = 0.84
			
			if hypothermia:
				speed_debuff = 0.45
			
			velocity.x = direction.x * speed * speed_debuff
			velocity.z = direction.z * speed * speed_debuff
			
			ui.held_item.get_node("AnimationPlayer").play("bob")
			ui.hand.get_node("AnimationPlayer").play("bob")
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
	ui.body.position = ui_lag_offset

	ui.fps.text = "%d" % Engine.get_frames_per_second()
	ui.dirtiness.text = "Dirt: %d" % GameManager.dirtiness
	
	if hallucinogen:
		hallucinogen_timer -= delta
		
		if hallucinogen_timer <= 0:
			hallucinogen_timer = 0.0
			hallucinogen = false
	
	if hypothermia:
		hypothermia_timer -= delta
		
		if hypothermia_timer <= 0:
			hypothermia_timer = 0.0
			hypothermia = false

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
			_interact()

	if raycast.is_colliding():
		var collider: Node = raycast.get_collider()
		if collider is InteractableComponent or collider is Item:
			if collider.show_tooltip_text:
				ui.show_tooltip(raycast.get_collider().tooltip_text)
	else:
		ui.hide_tooltip()

	if Input.is_action_just_pressed("drop"):
		drop_item(null)

func _interact() -> void:
	var hit: Node = raycast.get_collider()
	if not hit: return

	if hit is Baby:
		match held_item_id:
			ITEMS.IDS.swab:
				if held_item.baby_id == -1:
					held_item.use(hit.id)
					set_held_item_sprite(ITEMS.IDS.swab_used)
			ITEMS.IDS.antidote:
				hit.give_antidote(held_item)
				remove_held_item()

				Util.add_subtitle(Lang.subtitles.gave_antidote)
			ITEMS.IDS.baby:
				ui.show_warning(Lang.WARNINGS.pick_up_baby)
			_:
				pick_up(hit)
	elif hit is Item:
		if held_item:
			drop_item(hit)
		if hit.pickupable:
			pick_up(hit)
	elif hit is Dirt or hit is WaterSpill:
		if held_item_id == ITEMS.IDS.mop:
			hit.clean(self)
	elif hit is InteractableComponent:
		hit.interact()

func pick_up(item: Item) -> void:
	if held_item and ITEMS.undroppable.has(held_item_id): return

	if not ITEMS.IDS.has(item.internal_name):
		print("The ITEMS_ID does not have a record for the Internal Name of this Item.")
		return

	drop_item(null)
	set_held_item_sprite(ITEMS.IDS[item.internal_name])
	held_item = item

	item.hide()
	item.interact()
	item.picked_up.emit()

	if not ITEMS.unmovable.has(held_item_id):
		item.global_position = Vector3.ZERO

	item.set_collision_layer_value(1, false)
	ui.set_hand_sprite()

func drop_item(hit: Node) -> void:
	if held_item == null or ITEMS.undroppable.has(held_item_id):
		if held_item_id == ITEMS.IDS.baby:
			ui.show_warning(Lang.WARNINGS.drop_baby)
		return

	if hit == null:
		if not ITEMS.unmovable.has(held_item_id):
			held_item.global_position = global_position + Vector3(0, 0.5, 0)
		held_item.set_collision_layer_value(1, true)

		held_item.show()
		held_item.dropped.emit()
		held_item = null

		set_held_item_sprite("clipboard")

func set_held_item_sprite(sprite_name: String) -> void:
	held_item_id = sprite_name

	var held_item_sprite: TextureRect = TextureRect.new()
	held_item_sprite.texture = load(Registry.UID[sprite_name])

	for entry in ui.held_item.get_children():
		if entry is not AnimationPlayer:
			entry.queue_free()

	ui.held_item.add_child(held_item_sprite)
	ui.held_item.get_node("AnimationPlayer").play("get_item")

func remove_held_item() -> void:
	held_item.queue_free()
	held_item = null

	set_held_item_sprite("clipboard")

func throw_item() -> void:
	if not ITEMS.nonthrowable.has(held_item_id):
		remove_held_item()
	elif held_item_id != ITEMS.IDS.clipboard:
		ui.show_warning(Lang.WARNINGS.throw_item)

func stop_movement() -> void:
	can_move = false
	velocity = Vector3.ZERO

func set_movement() -> void:
	can_move = true
