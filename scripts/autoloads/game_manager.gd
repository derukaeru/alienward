extends Node

@onready var pause_screen: Node = load(Registry.UID["pause_screen"]).instantiate()

var SEED: int = 0
const UNASSIGNED: int = -1

var day: int = 0
var time: float = 0.0 
var money: int = 0

var canvas_layer: CanvasLayer = CanvasLayer.new()

var latest_npc_id: int = 1
var latest_baby_id: int = 1

var microscope_dna: String = ""
var dirtiness: float = 0.0

var has_interacted: bool = false
var selected_ward_on_ui: int = UNASSIGNED # i wonder what this variable is for
var clinic_open: bool = true

var waiting_seats_occupation: Array = [false, false, false, false, false, false]
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
	
	var container: Node = Util.get_group_node("entities_container")
	
	container.add_child(patient)
	container.add_child(npc)
	
	patient.npc_id = latest_npc_id + 1
	npc.patient_id = latest_npc_id + 1
	latest_npc_id += 1
	
	var npc_spawn: Vector3 = Util.get_npc_spot("npc_enter")
	var patient_spawn: Vector3 = Util.get_patient_spot("patient_enter")
	
	patient.global_position = patient_spawn
	npc.global_position = npc_spawn
	
	for i in len(waiting_seats_occupation):
		if not waiting_seats_occupation[i]:
			patient.waiting_seat_position = i
			npc.waiting_seat_position = i
			
			waiting_seats_occupation[i] = true
