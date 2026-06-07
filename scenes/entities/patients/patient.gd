class_name Patient extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
var speed: float = 2.4
var gravity: float = 9.8
var npc_id: int = -1

enum REASONS {
	CHECKUP,
	LABOR
}

var reason: REASONS = REASONS.CHECKUP
var maternity_stage: int = 0

var target_name: String = ""
var guided: bool = false
var waiting_seat_position: int = -1

func set_stage() -> void:
	if randf_range(0.0, 1.0) > 0.55: # pregnant
		maternity_stage = 4
		reason = REASONS.LABOR
	else: 
		maternity_stage = randi_range(1, 3)
		reason = REASONS.CHECKUP

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
	
	var player: CharacterBody3D = Util.get_player()
	
	if reason == REASONS.CHECKUP:
		player.ui_layer.checkup.show() 
	elif reason == REASONS.LABOR:
		player.ui_layer.guide_patient.show() 

func _process(_delta) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and guided:
		guided = false
		
		if reason == REASONS.CHECKUP:
			Util.get_player().ui_layer.checkup.hide() 
		elif reason == REASONS.LABOR:
			Util.get_player().ui_layer.guide_patient.hide() 

# TODO HERE
func target_reached():
	if target_name == "waiting": 
		if waiting_seat_position < 0: return
		
		global_position = Util.get_patient_spot("seat_%d" % waiting_seat_position)
	elif target_name == "ward":
		pass
	elif target_name == "checkup":
		pass
