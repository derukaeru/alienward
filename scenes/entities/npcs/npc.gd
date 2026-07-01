class_name NPC extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var speed: float = 2.4
var patient_id: int = GameManager.UNASSIGNED
var gravity: float = 9.8

var target_name: String = ""
var waiting_seat_position: int = GameManager.UNASSIGNED

var ready_to_recieve_baby: bool = false
var ready_to_leave: bool = false

func _ready() -> void:
	move_to("seat_%d" % waiting_seat_position)
	EventBus.incubated_child.connect(look_at_child)

func move_to(_name) -> void:
	target_name = _name
	nav_agent.target_position = Util.get_npc_spot(_name)

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
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == ITEMS.IDS.baby:
		var baby: Baby = player.held_item
		
		if baby.patient_id == patient_id and ready_to_recieve_baby:
			player.remove_held_item()
			ready_to_leave = true
			# TODO

func target_reached() -> void:
	if target_name.begins_with("seat_"):
		global_position = Util.get_npc_spot("seat_%d" % waiting_seat_position)
		target_name = ""
	if target_name.begins_with("watch_baby_"):
		ready_to_recieve_baby = true
		global_position = Util.get_npc_spot(target_name)

func look_at_child(child_id: int) -> void:
	if child_id != patient_id: return
	
	var available_spots: Array = []
	for i in range(GameManager.watch_baby):
		if not GameManager.watch_baby[i]:
			available_spots.append(i)
	
	if available_spots.is_empty():
		print("no available spots")
		return
	
	var spot_index: int = available_spots[randi() % available_spots.size()]
	move_to("watch_baby_%d" % spot_index)

func leaving_checkup() -> void:
	pass
