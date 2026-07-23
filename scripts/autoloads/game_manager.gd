extends Node

@onready var pause_screen: Node = load(Registry.UID.pause_screen).instantiate()
@onready var settings_screen: Node = load(Registry.UID.settings_screen).instantiate()
@onready var ui: CanvasLayer = load(Registry.UID.ui).instantiate()

var canvas_layer: CanvasLayer = CanvasLayer.new()

var SEED: int = 232421
const UNASSIGNED: int = -1

var current_day: int = 0
var day_going: bool = false
var processed_patient_this_day: int = 0

var DEFAULT_TIME_LENGTH: float = 60 * 10 # 10 minutes
var time: float = DEFAULT_TIME_LENGTH
var money: int = 0

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
	
	canvas_layer.add_child(ui)
	canvas_layer.add_child(pause_screen)
	
	ui.hide()
	pause_screen.hide()
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.add_money.connect(add_money)

func _process(delta: float) -> void:
	if day_going:
		time -= delta
		
		if time <= 0:
			end_day()
	
	var player: Player = Util.get_player()
	if not player: return
	
	if player.ui.shop_open or player.ui.microscope_open: return
	
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
	
	time = DEFAULT_TIME_LENGTH
	day_going = true

func end_day() -> void:
	day_going = false
	time = 0

func reset_day() -> void:
	# clear baby, patient, items
	# open all curtains
	# remove ultrasound
	# remove antidote base
	# remove all effects
	# clear microscope
	
	pass

func get_ui() -> CanvasLayer:
	return ui
