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

var DEFAULT_TIME_LENGTH: float = 60 * 8 # 8 minutes
var time: float = DEFAULT_TIME_LENGTH
var time_between_patients: float = 60 * 1.5 # 2 minutes
var time_until_next_patient: float = time - 2 # 2 seconds after game starts

var money_earned: int = 0
var money: int = 0

var latest_patient_id: int = 1
var latest_baby_id: int = 1

var microscope_dna: String = ""
var dirtiness: float = 0.0
var patient_satisfaction: float = 0.0

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

var patient_queue: int = 0
var save_timer: float = 60 * 5 # 5 minutes

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
	if not get_tree().paused:
		if save_timer > 0:
			save_timer -= delta
		
		if save_timer <= 0:
			save_timer = 60 * 5
			SaveManager.save_progress()
		
		if day_going:
			time -= delta
			day_running()
			
			if time <= 0:
				end_day()
	
	if not day_going: return
	if ui.shop_open or ui.microscope_open: return
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			if pause_screen.settings_screen.visible:
				pause_screen._settings_exit_pressed()
			else:
				unpause()
		else:
			pause()
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		has_interacted = false

func unpause() -> void:
	get_tree().paused = false
	pause_screen.animation.play_backwards("toggle")
	
	await pause_screen.animation.animation_finished
	
	pause_screen.hide()
	Util.mouse_captured()

func pause() -> void:
	get_tree().paused = true
	pause_screen.animation.play("toggle")
	
	pause_screen.show()
	Util.mouse_visible()

func add_money(amount: int) -> void:
	money += amount
	money_earned += amount

func spawn_patient() -> void:
	var available_seats: Array = []
	for i in len(waiting_seats_occupation):
		if waiting_seats_occupation[i] == false:
			available_seats.append(i)
	
	if available_seats.is_empty(): 
		print("no available seat")
		patient_queue += 1
		return
	else:
		if patient_queue > 0: patient_queue -= 1
	
	var patient: Patient = load(Registry.UID["patient"]).instantiate()
	var npc: NPC = load(Registry.UID["npc"]).instantiate()
	
	patient.id = latest_patient_id + 1
	npc.patient_id = latest_patient_id + 1
	
	latest_patient_id += 1
	npc.patient = patient
	
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

func start_day(day: int = current_day) -> void:
	if current_day >= 7: return
	
	time = DEFAULT_TIME_LENGTH
	time_until_next_patient = time - 2
	current_day = day
	day_going = true
	
	EventBus.day_started.emit()
func end_day() -> void:
	day_going = false
	time = 0
	
	EventBus.day_ended.emit()
	get_tree().create_timer(2.0).timeout.connect(func() -> void:
		SceneChanger.change_scene("end_day_screen")
	)
func reset_day() -> void:
	EventBus.add_end_screen_details.emit(processed_patient_this_day, dirtiness, patient_satisfaction, money_earned)
	
	day_going = false
	time = DEFAULT_TIME_LENGTH
	time_until_next_patient = time - 2
	
	processed_patient_this_day = 0
	money_earned = 0
	
	latest_baby_id = 1
	latest_patient_id = 1
	
	microscope_dna = ""
	dirtiness = 0
	
	has_interacted = false
	selected_ward_on_ui = UNASSIGNED
	clinic_open = true
	
	waiting_seats_occupation = [false, false, false, false, false, false]
	watch_baby = [false, false, false, false, false, false, false]
	ward_occupation = [false, false, false, false]
	
	patient_queue = 0

func day_running() -> void:
	if not day_going: return
	
	var player: Player = Util.get_player()
	if not player: return
	
	#if get_tree().get_nodes_in_group("patient").size() <= 0:
		#spawn_patient()
	if time <= time_until_next_patient:
		time_until_next_patient = time - time_between_patients
		spawn_patient()
