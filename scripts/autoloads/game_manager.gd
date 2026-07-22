extends Node

@onready var pause_screen: Node = load(Registry.UID["pause_screen"]).instantiate()
@onready var settings_screen: Node = load(Registry.UID["settings_screen"]).instantiate()

var SEED: int = 232421
const UNASSIGNED: int = -1

var current_day: int = 0
var day_going: bool = false
var processed_patient_this_day: int = 0

var time: float = 0.0 
var money: int = 0

var canvas_layer: CanvasLayer = CanvasLayer.new()

var latest_patient_id: int = 1
var latest_baby_id: int = 1

var microscope_dna: String = ""
var dirtiness: float = 0.0

var has_interacted: bool = false
var selected_ward_on_ui: int = UNASSIGNED
var clinic_open: bool = true

var waiting_seats_occupation: Array = [false, false, false, false, false, false]
var watch_baby: Array = [false, false, false, false, false, false, false]
var ward_occupation: Array = [false, false, false, false]

enum REASONS {
	CHECKUP,
	LABOR
}

func _ready() -> void:
	seed(SEED)
	add_child(canvas_layer)
	
	canvas_layer.add_child(pause_screen)
	pause_screen.hide()
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_d) -> void:
	if day_going:
		var patient_amount: int = Util.get_group_nodes("patient").size()
		if patient_amount <= 0:
			spawn_patient()
	
	var player: Player = Util.get_player()
	if not player: return
	
	if player.ui_layer.shop_open or player.ui_layer.microscope_open: return
	
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			pause_screen.hide()
			Util.mouse_captured()
		else:
			get_tree().paused = true
			pause_screen.show()
			Util.mouse_visible()
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		has_interacted = false

func add_money(amount: int) -> void:
	money += amount

func spawn_patient() -> void:
	var patient: Patient = load(Registry.UID["patient"]).instantiate()
	var npc: NPC = load(Registry.UID["npc"]).instantiate()
	
	patient.id = latest_patient_id + 1
	npc.patient_id = latest_patient_id + 1
	
	latest_patient_id += 1
	npc.patient = patient
	
	var available_seats: Array = []
	for i in len(waiting_seats_occupation):
		if waiting_seats_occupation[i] == false:
			available_seats.append(i)
	
	if available_seats.is_empty(): 
		print("no available seat")
	else:
		var seat_index: int = available_seats[randi() % available_seats.size()]
		patient.waiting_seat_position = seat_index
		npc.waiting_seat_position = seat_index
		
		waiting_seats_occupation[seat_index] = true
	
	Util.add_entity_to_container(patient)
	Util.add_entity_to_container(npc)
	
	var npc_spawn: Vector3 = Util.get_npc_spot("npc_enter")
	var patient_spawn: Vector3 = Util.get_patient_spot("patient_enter")
	
	patient.global_position = patient_spawn
	npc.global_position = npc_spawn

func start_game() -> void:
	pass

func start_day(_day: int = current_day) -> void:
	if current_day >= 7: return
	day_going = true

func end_day() -> void:
	pass

func reset_for_day() -> void:
	# clear baby, patient, items
	# open all curtains
	# remove ultrasound
	# remove antidote base
	# remove all effects
	# clear microscope
	
	pass
