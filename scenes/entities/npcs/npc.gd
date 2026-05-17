extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
var speed := 3.2

func move_to(target_pos: Vector3):
	nav_agent.target_position = target_pos

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		return
	
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
