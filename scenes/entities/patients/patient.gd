class_name Patient extends CharacterBody3D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var nav_agent = $NavigationAgent3D

@onready var scanning_sprite_pivot: Node3D = $ScanningSpritePivot
@onready var scanning_sprite: Sprite3D = $ScanningSpritePivot/ScanningSprite

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var bubble_container: Node3D = $bubble_container

var speed: float = 2.32
var gravity: float = 9.8
var id: int = GameManager.UNASSIGNED

enum STATES {
	RESTING,
	LABOR,
	WALKING,
	IDLE,
	WAITING,
	CHECKUP,
	READY_TO_LEAVE
}
var state: STATES = STATES.IDLE

var scanning: bool = false
var scanned: bool = false
var scan_sprite_offset: float = 0.3
var has_ultrasound: bool = false

var scanning_timer: Timer
var scan_time: float = 5.0

@export var reason: GameManager.REASONS = GameManager.REASONS.CHECKUP
var maternity_stage: int = GameManager.UNASSIGNED

var target_name: String = ""
var guided: bool = false

var labor_timer: SceneTreeTimer
var rest_timer: SceneTreeTimer

var labor_speed: float = 1.0
var rest_speed: float = 1.0

var waiting_seat_position: int = GameManager.UNASSIGNED
var ward_index: int = GameManager.UNASSIGNED

var moving: bool = false
var look_target: Vector3

func _ready() -> void:
	set_stage()

	if waiting_seat_position == GameManager.UNASSIGNED: return
	move_to("seat_%d" % waiting_seat_position)

func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if not nav_agent.is_navigation_finished():
		var next = nav_agent.get_next_path_position()
		var direction = (next - global_position).normalized()
		velocity = direction * speed

		if velocity.length() > 0.1:
			moving = true

		move_and_slide()
	else:
		moving = false

	if state == STATES.WALKING:
		if moving:
			look_target = Vector3(velocity.x, 0, velocity.z)
		else:
			look_at_target(Util.get_patient_spot("waiting"))

		if not animation.is_playing():
			animation.play("walk")

	rotation.y = lerp_angle(rotation.y, atan2(-look_target.x, -look_target.z), .1)

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return

	if scanning:
		var player_collider: Node = player.raycast.get_collider()
		if not player_collider == interactable_component:
			scanning = false
			print("stopped scanning")

			scanning_timer.stop()
			scanning_timer.queue_free()

			scanning_sprite.hide()
		else:
			scanning_sprite.show()
			var to_player: Vector3 = (player.global_position - scanning_sprite_pivot.global_position)
			to_player.y = 0.0
			to_player.normalized()

			scanning_sprite.global_position = scanning_sprite_pivot.global_position + to_player * scan_sprite_offset

	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and guided and STATES.WAITING:
		guided = false

		if reason == GameManager.REASONS.CHECKUP:
			player.ui_layer.checkup.hide()
			player.ui_layer.patient_open = false

			if GameManager.clinic_open:
				move_to("checkup")
				GameManager.clinic_open = false
				Util.add_subtitle(Lang.subtitles.guide_patient)
		elif reason == GameManager.REASONS.LABOR:
			player.ui_layer.guide_patient.hide()
			player.ui_layer.patient_open = false

			if GameManager.selected_ward_on_ui >= 0:
				ward_index = GameManager.selected_ward_on_ui

				move_to("ward_%d" % ward_index)
				GameManager.selected_ward_on_ui = GameManager.UNASSIGNED
				EventBus.patient_to_ward.emit(id)

				Util.add_subtitle(Lang.subtitles.guide_patient)

func set_stage() -> void:
	var chance: float = randf_range(0.0, 1.0)

	if chance > 0.55:
		maternity_stage = 4
		reason = GameManager.REASONS.LABOR

		#labor_speed = randf_range(25.0, 45.0)
		#rest_speed = randf_range(55.0, 75.0)
	else:
		maternity_stage = randi_range(1, 3)
		reason = GameManager.REASONS.CHECKUP

func move_to(_name: String) -> void:
	state = STATES.WALKING

	target_name = _name
	nav_agent.target_position = Util.get_patient_spot(_name)

func interacted() -> void:
	if state == STATES.WAITING:
		guided = true

	var player: Player = Util.get_player()
	if not player: return

	if state == STATES.WAITING and player.held_item_id == ITEMS.IDS.clipboard:
		EventBus.open_patient_screen.emit(reason)
	elif state == STATES.CHECKUP:
		if player.held_item_id == ITEMS.IDS.ultrasound_scanner and not scanned:
			scanning = true

			scanning_timer = Timer.new()
			scanning_timer.one_shot = true
			add_child(scanning_timer)

			scanning_timer.start(scan_time)
			scanning_timer.timeout.connect(scan_done)

		if player.held_item_id == ITEMS.IDS.ultrasound_print:
			if player.held_item.patient_id == id:
				has_ultrasound = true
				player.remove_held_item()

				state = STATES.READY_TO_LEAVE
				EventBus.patient_leaving_clinic.emit(id)

				# TODO: leave

func scan_done() -> void:
	scanned = true
	scanning = false

	scanning_sprite.hide()
	EventBus.patient_scanned.emit(id)
	Util.add_subtitle(Lang.subtitles.scanned_patient)

func look_at_target(target: Vector3) -> void:
	look_target = target - global_position

	look_target.y = 0
	look_target = look_target.normalized()

func remove_bubble() -> void:
	for entry in bubble_container.get_children():
		entry.queue_free()

func add_bubble() -> void:
	var bubble = Registry.status_bubble.instantiate()
	bubble_container.add_child(bubble)

func target_reached() -> void:
	if target_name.begins_with("ward_"):
		target_name = "inside_ward_%d" % ward_index
		global_position = Util.get_patient_spot(target_name)

		labor_timer = get_tree().create_timer(labor_speed)
		labor_timer.timeout.connect(birth_child)

		EventBus.close_curtain.emit(ward_index)
		EventBus.patient_reached_ward.emit(id)

		state = STATES.LABOR
	elif target_name.begins_with("seat_"):
		global_position = Util.get_patient_spot("seat_%d" % waiting_seat_position)
		state = STATES.WAITING

		look_at_target(Util.get_patient_spot("waiting"))
	elif target_name == "checkup":
		global_position = Util.get_patient_spot("checkup_seat")
		state = STATES.CHECKUP
		EventBus.patient_reached_clinic.emit(id)
	elif target_name == "patient_enter":
		queue_free()
		EventBus.left.emit(id)

func birth_child() -> void:
	if state != STATES.LABOR: return

	var child: Baby = load(Registry.UID.baby).instantiate()
	Util.add_entity_to_container(child)

	child.patient_id = id
	child.id = GameManager.latest_baby_id + 1
	GameManager.latest_baby_id += 1

	EventBus.deliver_child.emit(ward_index, child)

	state = STATES.RESTING
	rest_timer = get_tree().create_timer(rest_speed)
	rest_timer.timeout.connect(
		func() -> void:
			state = STATES.READY_TO_LEAVE
	)
