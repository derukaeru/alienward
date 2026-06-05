extends Node

var npc_spots: Dictionary
var patient_spots: Dictionary

func get_npc_spot(spot_name: String) -> Vector3:
	if not npc_spots: get_npc_spots()
	return npc_spots[spot_name].global_position
	
func get_patient_spot(spot_name: String) -> Vector3:
	if not patient_spots: get_patient_spots()
	return patient_spots[spot_name].global_position

func get_npc_spots() -> Dictionary:
	if not npc_spots:
		npc_spots = get_tree().get_first_node_in_group("map").npc_spots
	return npc_spots
	
func get_patient_spots() -> Dictionary:
	if not patient_spots:
		patient_spots = get_tree().get_first_node_in_group("map").patient_spots
	return patient_spots

func get_player() -> Node3D:
	return get_tree().get_first_node_in_group("player")
	
func get_main() -> Node3D:
	return get_tree().current_scene

func get_group_node(group) -> Node:
	return get_tree().get_first_node_in_group(group)

func mouse_visible() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func mouse_captured() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_baby_with_id(id: int):
	for entry in get_tree().get_nodes_in_group("baby"):
		if entry.id == id:
			return entry
