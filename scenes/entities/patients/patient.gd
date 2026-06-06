class_name Patient extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
var speed: float = 3.2
var npc_id: int = -1

enum REASON {
	CHECKUP,
	LABOR
}

var reason: REASON = REASON.CHECKUP
var maternity_stage: int = 0

var target_name: String = ""

func set_stage() -> void:
	if randf_range(0.0, 1.0) > 0.55: # pregnant
		maternity_stage = 4
		reason = REASON.LABOR
	else: 
		maternity_stage = randi_range(1, 3)
		reason = REASON.CHECKUP

func _ready() -> void:
	set_stage()
	move_to("waiting")

func move_to(_name: String) -> void:
	target_name = _name
	nav_agent.target_position = Util.get_patient_spot(_name)

func _physics_process(_delta) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func interacted():
	pass 

# TODO HERE
func target_reached():
	if target_name == "waiting": 
		pass
	elif target_name == "ward":
		pass
	elif target_name == "checkup":
		pass
