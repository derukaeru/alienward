class_name NPC extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var bubble_container: Node3D = $bubble_container

var speed: float = 2.4
var patient_id: int = GameManager.UNASSIGNED
var gravity: float = 9.8

var target_name: String = ""
var waiting_seat_position: int = GameManager.UNASSIGNED

var ready_to_recieve_baby: bool = false
var has_baby: bool = false
var patient: Patient

var moving: bool = false

enum STATES {
	IDLE,
	WAITING,
	WALKING,
	GUIDING_TO_WARD,
	WATCHING_BABY,
	WAITING_FOR_PATIENT,
	GUIDING_OUT_OF_WARD,
	GUIDING_OUTSIDE
}
var state: STATES = STATES.IDLE
var look_target: Vector3

func _ready() -> void:
	if waiting_seat_position:
		move_to("seat_%d" % waiting_seat_position)
		add_status_bubble("waiting")

	EventBus.incubated_child.connect(look_at_child)
	EventBus.patient_to_ward.connect(escort_patient)
	EventBus.patient_reached_ward.connect(
		func(id: int) -> void:
			if patient_id == id:
				move_to("seat_%d" % waiting_seat_position)
				#add_status_bubble("waiting")
	)

	patient = Util.get_patient_with_id(patient_id)

func move_to(_name: String) -> void:
	state = STATES.WALKING

	target_name = _name
	nav_agent.target_position = Util.get_npc_spot(_name)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if not nav_agent.is_navigation_finished():
		var next = nav_agent.get_next_path_position()
		var direction = (next - global_position).normalized()
		velocity = direction * speed

		if velocity.length() > 0.1:
			moving = true
		else:
			moving = false

		move_and_slide()

	if state == STATES.WALKING or state == STATES.GUIDING_TO_WARD or state == STATES.GUIDING_OUT_OF_WARD or state == STATES.GUIDING_OUTSIDE:
		look_target = Vector3(velocity.x, 0, velocity.z)
		
		if not animation.is_playing():
			animation.play("walk")
	
	rotation.y = lerp_angle(rotation.y, atan2(-look_target.x, -look_target.z), .1)

func _process(_delta: float) -> void:
	if state == STATES.GUIDING_TO_WARD and target_name != "follow_patient":
		if global_position.distance_to(patient.global_position) < 1.2: return
		nav_agent.target_position = patient.global_position
		target_name = "follow_patient"
		add_status_bubble("following_patient")
	elif state == STATES.WAITING_FOR_PATIENT:
		if has_baby and patient.state == patient.STATES.RESTED:
			move_to("ward_%d" % patient.ward_index)
			state = STATES.GUIDING_OUT_OF_WARD
			add_status_bubble("guiding_out_of_ward")
	elif state == STATES.GUIDING_OUTSIDE and target_name != "leaving_with_patient":
		if global_position.distance_to(patient.global_position) < 1.2: return
		
		nav_agent.target_position = patient.global_position
		target_name = "leaving_with_patient"
		add_status_bubble("following_patient")

func interacted() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == ITEMS.IDS.baby:
		var baby: Baby = player.held_item
	
		if baby.patient_id == patient_id and ready_to_recieve_baby and baby.is_cured and baby.is_incubated:
			player.remove_held_item()
			has_baby = true
			state = STATES.WAITING_FOR_PATIENT

func look_at_target(target: Vector3) -> void:
	look_target = target - global_position
	
	look_target.y = 0
	look_target = look_target.normalized()

func remove_status_bubble() -> void:
	for entry in bubble_container.get_children():
		entry.free()

func add_status_bubble(type: String) -> void:
	var bubble: StatusBubble = load(Registry.UID.status_bubble_instance).instantiate()
	bubble.status_type = "status_" + type

	bubble_container.add_child(bubble)

func target_reached() -> void:
	remove_status_bubble()

	if target_name.begins_with("seat_"):
		global_position = Util.get_npc_spot("seat_%d" % waiting_seat_position)
		target_name = ""

		state = STATES.WAITING
		look_at_target(Util.get_npc_spot("waiting"))
	elif target_name.begins_with("watch_baby_"):
		ready_to_recieve_baby = true
		global_position = Util.get_npc_spot(target_name)
		state = STATES.WATCHING_BABY
		add_status_bubble("watching_baby")
	elif target_name == "follow_patient":
		target_name = ""
	elif target_name.begins_with("ward_"):
		patient.leave_ward()
		state = STATES.GUIDING_OUTSIDE
	elif target_name == "leaving_with_patient":
		target_name = ""

func look_at_child(child_id: int) -> void:
	if child_id != patient_id: return

	var available_spots: Array = []
	for i in GameManager.watch_baby.size():
		if not GameManager.watch_baby[i]:
			available_spots.append(i)

	if available_spots.is_empty():
		print("no available spots")
		return

	var spot_index: int = available_spots[randi() % available_spots.size()]
	move_to("watch_baby_%d" % spot_index)

func leaving_checkup() -> void:
	pass

func escort_patient(id: int) -> void:
	if id != patient_id: return

	state = STATES.GUIDING_TO_WARD
