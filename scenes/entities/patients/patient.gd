class_name Patient extends CharacterBody3D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var nav_agent = $NavigationAgent3D
var speed: float = 2.4
var gravity: float = 9.8
var npc_id: int = GameManager.UNASSIGNED

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

func _ready() -> void:
	set_stage()
	
	#labor_speed = randf_range(25.0, 45.0)
	#rest_speed = randf_range(55.0, 75.0)
	
	move_to("waiting")

func set_stage() -> void:
	var chance: float = randf_range(0.0, 1.0)
	
	if chance > 0.55:
		maternity_stage = 4
		reason = GameManager.REASONS.LABOR
	else: 
		maternity_stage = randi_range(1, 3)
		reason = GameManager.REASONS.CHECKUP

func move_to(_name: String) -> void:
	state = STATES.WALKING
	
	target_name = _name
	nav_agent.target_position = Util.get_patient_spot(_name)

func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if nav_agent.is_navigation_finished():
		return
	
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func interacted() -> void:
	if state == STATES.WAITING:
		guided = true
	
	var player: Player = Util.get_player()
	if not player: return
	
	if state == STATES.WAITING and player.held_item_id == ITEMS.IDS.clipboard: 
		player.ui_layer.open_patient_screen(reason)
	elif state == STATES.CHECKUP:
		if player.held_item_id == ITEMS.IDS.ultrasound_scanner and not scanned:
			scanning = true
			print("scanning")
			
			scanning_timer = Timer.new()
			scanning_timer.one_shot = true
			add_child(scanning_timer)
			
			scanning_timer.start(scan_time)
			scanning_timer.timeout.connect(scan_done)
		elif player.held_item_id == ITEMS.IDS.ultrasound_print:
			if player.held_item.patient_id == npc_id:
				has_ultrasound = true
				player.remove_held_item()
				move_to("patient_enter")

func scan_done() -> void:
	scanned = true
	scanning = false
	
	print("done scan")
	
	var ultrasound_screen: InteractableComponent = Util.get_group_node("ultrasound_screen")
	if not ultrasound_screen: return
	
	ultrasound_screen.scanned_patient_id = npc_id

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
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and guided and STATES.WAITING:
		guided = false
		
		
		if reason == GameManager.REASONS.CHECKUP:
			player.ui_layer.checkup.hide() 
			player.ui_layer.patient_open = false
			
			if GameManager.clinic_open:
				move_to("checkup")
				GameManager.clinic_open = false
		elif reason == GameManager.REASONS.LABOR:
			player.ui_layer.guide_patient.hide() 
			player.ui_layer.patient_open = false
			
			if GameManager.selected_ward_on_ui >= 0:
				ward_index = GameManager.selected_ward_on_ui
				
				move_to("ward_%d" % ward_index)
				GameManager.selected_ward_on_ui = -1

func target_reached() -> void:
	if ["ward_0", "ward_1", "ward_2", "ward_3"].has(target_name):
		target_name = "inside_ward_%d" % ward_index
		global_position = Util.get_patient_spot(target_name)
		
		state = STATES.IDLE
		
		for entry in Util.get_group_nodes("curtain"):
			if entry.name == "curtain_%d" % ward_index:
				entry.close()
	
	if ["inside_ward_0", "inside_ward_1", "inside_ward_2", "inside_ward_3"].has(target_name):
		labor_timer = get_tree().create_timer(labor_speed)
		labor_timer.timeout.connect(birth_child)
		
		state = STATES.LABOR
	
	match target_name:
		"waiting": 
			if waiting_seat_position == GameManager.UNASSIGNED: return
			global_position = Util.get_patient_spot("seat_%d" % waiting_seat_position)
			
			state = STATES.WAITING
		"checkup":
			global_position = Util.get_patient_spot("checkup_seat")
			
			state = STATES.CHECKUP

func birth_child() -> void:
	if state != STATES.LABOR: return
	
	var child: Baby = load(Registry.UID["baby"]).instantiate()
	var container = Util.get_group_node("entities_container")
	container.add_child(child)
	
	for entry in Util.get_group_nodes("delivery_table"):
		if entry.name == "delivery_table_%d" % ward_index:
			child.delivery_table = entry
			child.is_in_delivery_table = true
			
			entry.held_baby = child
			entry.change_tooltip()
	
	var delivery_table = Util.get_patient_spot("delivery_table_%d" % ward_index)
	child.global_position = delivery_table
	
	state = STATES.RESTING
	rest_timer = get_tree().create_timer(rest_speed)
	rest_timer.timeout.connect(
		func() -> void:
			state = STATES.READY_TO_LEAVE
	)
