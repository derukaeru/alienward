class_name NPC extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var speed: float = 2.4
var patient_id: int = GameManager.UNASSIGNED
var gravity: float = 9.8

var target_name: String = ""
var waiting_seat_position: int = GameManager.UNASSIGNED

var ready_to_recieve_baby: bool = false
var ready_to_leave: bool = false
var patient: Patient

enum STATES {
	IDLE,
	WAITING,
	GUIDING_TO_WARD,
	WAITING_FOR_PATIENT,
	WATCHING_BABY,
	GUIDING_OUT_OF_WARD
}
var state: STATES = STATES.IDLE

func _ready() -> void:
	if waiting_seat_position:
		move_to("seat_%d" % waiting_seat_position)
	
	EventBus.incubated_child.connect(look_at_child)
	EventBus.patient_to_ward.connect(escort_patient)
	EventBus.patient_reached_ward.connect(
		func(id: int) -> void:
			if patient_id == id:
				move_to("seat_%d" % waiting_seat_position)
				state = STATES.WAITING
	)
	
	patient = Util.get_patient_with_id(patient_id)

func move_to(_name: String) -> void:
	target_name = _name
	nav_agent.target_position = Util.get_npc_spot(_name)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if nav_agent.is_navigation_finished(): return
	
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()
	velocity = direction * speed
	
	if velocity.length() > 0.1:
		var look_target = global_position + Vector3(velocity.x, 0, velocity.z)
		look_at(look_target, Vector3.UP)
	
	move_and_slide()

func _process(_delta: float) -> void:
	if state == STATES.GUIDING_TO_WARD and target_name != "follow_patient":
		if global_position.distance_to(patient.global_position) < 1: return
		
		nav_agent.target_position = patient.global_position
		target_name = "follow_patient"
	elif state == STATES.GUIDING_OUT_OF_WARD:
		pass

func interacted() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == ITEMS.IDS.baby:
		var baby: Baby = player.held_item
		
		if baby.patient_id == patient_id and ready_to_recieve_baby and baby.is_cured:
			player.remove_held_item()
			ready_to_leave = true
			
			move_to("ward_%d" % patient.ward_index)
			state = STATES.GUIDING_OUT_OF_WARD

func target_reached() -> void:
	if target_name.begins_with("seat_"):
		global_position = Util.get_npc_spot("seat_%d" % waiting_seat_position)
		target_name = ""
		state = STATES.WAITING
	elif target_name.begins_with("watch_baby_"):
		ready_to_recieve_baby = true
		global_position = Util.get_npc_spot(target_name)
		state = STATES.WATCHING_BABY
	elif target_name == "follow_patient":
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
	
