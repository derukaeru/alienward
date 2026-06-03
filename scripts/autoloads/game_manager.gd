extends Node

@onready var pause_screen: Node = load(Registry.UID["pause_screen"]).instantiate()
@onready var shop_screen: Node = load(Registry.UID["shop_screen"]).instantiate()
@onready var microscope_screen: Node = load(Registry.UID["microscope_screen"]).instantiate()

var day: int = 0
var time: float = 0.0 
var money: int = 0

var shop_open: bool = false
var microscope_open: bool = false
var canvas_layer: CanvasLayer = CanvasLayer.new()

var latest_npc_id: int = 1

func _ready() -> void:
	add_child(canvas_layer)
	
	canvas_layer.add_child(shop_screen)
	canvas_layer.add_child(pause_screen)
	
	pause_screen.hide()
	shop_screen.hide()
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_d) -> void:
	if shop_open or microscope_open: return
	
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			pause_screen.hide()
			Util.mouse_captured()
		else:
			get_tree().paused = true
			pause_screen.show()
			Util.mouse_visible()

func add_money(amount: int) -> void:
	money += amount

func open_shop_screen() -> void:
	shop_screen.show()
	
	shop_open = true
	Util.get_player().can_move = false
	Util.get_player().velocity = Vector3.ZERO

func open_microscope_screen() -> void:
	microscope_screen.show()
	microscope_open = true
	
	Util.get_player().can_move = false
	Util.get_player().velocity = Vector3.ZERO

func spawn_patient() -> void:
	var patient = load(Registry.UID["patient"]).instantiate()
	var npc = load(Registry.UID["npc"]).instantiate()
	
	var container = Util.get_group_node("entities_container")
	
	container.add_child(patient)
	container.add_child(npc)
	
	patient.npc_id = latest_npc_id + 1
	npc.patient_id = latest_npc_id + 1
	latest_npc_id += 1
	
	var npc_spawn = Util.get_npc_spot("npc_enter")
	var patient_spawn = Util.get_patient_spot("patient_enter")
	
	patient.global_position = patient_spawn
	npc.global_position = npc_spawn
