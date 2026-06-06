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

func set_stage() -> void:
	if randf_range(0.0, 1.0) > 0.55: # pregnant
		maternity_stage = 4
		reason = REASON.LABOR
	else: 
		maternity_stage = randi_range(1, 3)
		reason = REASON.CHECKUP

func _ready() -> void:
	set_stage()
	move_to(Util.get_patient_spot("waiting"))

func move_to(target_pos: Vector3) -> void:
	nav_agent.target_position = target_pos

func _physics_process(_delta) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func interacted():
	pass 
