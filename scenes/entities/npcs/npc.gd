class_name NPC extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var speed: float = 3.2
var patient_id: int = -1

func _ready() -> void:
	move_to(Util.get_npc_spot("waiting"))

func move_to(target_pos: Vector3) -> void:
	nav_agent.target_position = target_pos

func _physics_process(_delta) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
