class_name Patient extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
var speed: float = 2.4
var gravity: float = 9.8
var npc_id: int = GameManager.UNASSIGNED


var reason: GameManager.REASONS = GameManager.REASONS.CHECKUP
var maternity_stage: int = GameManager.UNASSIGNED

var target_name: String = ""
var guided: bool = false
var waiting_seat_position: int = GameManager.UNASSIGNED
var ward_index: int = GameManager.UNASSIGNED

func set_stage() -> void:
	var chance: float = randf_range(0.0, 1.0)
	
	if chance > 0.55:
		maternity_stage = 4
		reason = GameManager.REASONS.LABOR
	else: 
		maternity_stage = randi_range(1, 3)
		reason = GameManager.REASONS.CHECKUP

func _ready() -> void:
	set_stage()
	move_to("waiting")

func move_to(_name: String) -> void:
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

func interacted():
	guided = true
	
	var player: Player = Util.get_player()
	if not player or ward_index != GameManager.UNASSIGNED: return
	
	player.ui_layer.open_patient_screen(reason)

func _process(_delta) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and guided:
		guided = false
		
		if reason == GameManager.REASONS.CHECKUP:
			Util.get_player().ui_layer.checkup.hide() 
			
			if GameManager.clinic_open:
				move_to("checkup")
				GameManager.clinic_open = false
		elif reason == GameManager.REASONS.LABOR:
			Util.get_player().ui_layer.guide_patient.hide() 
			
			if GameManager.selected_ward_on_ui >= 0:
				ward_index = GameManager.selected_ward_on_ui
				
				move_to("ward_%d" % ward_index)
				GameManager.selected_ward_on_ui = -1

func target_reached() -> void:
	if ["ward_0", "ward_1", "ward_2", "ward_3"].has(target_name):
		global_position = Util.get_patient_spot(target_name)
		global_position = Util.get_patient_spot("inside_ward_%d" % ward_index)
	
	match target_name:
		"waiting": 
			if waiting_seat_position == GameManager.UNASSIGNED: return
			global_position = Util.get_patient_spot("seat_%d" % waiting_seat_position)
		"checkup":
			global_position = Util.get_patient_spot("checkup_seat")
