class_name NPC extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var speed: float = 3.2
var patient_id: int = -1

var target_name: String = ""

func _ready() -> void:
	move_to("waiting")

func move_to(_name) -> void:
	target_name = _name
	nav_agent.target_position = Util.get_npc_spot(_name)

func _physics_process(_delta) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var next = nav_agent.get_next_path_position()
	var direction = (next - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func interacted():
	var player: CharacterBody3D = Util.get_player()
	
	if player.held_item_id == player.ITEMS_ID.baby:
		var baby: Baby = player.held_item
		
		if baby.patient_id == patient_id:
			pass

func target_reached():
	if target_name == "waiting":
		pass
