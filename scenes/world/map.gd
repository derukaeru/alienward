extends Node3D

var npc_spots: Dictionary = {}
var patient_spots: Dictionary = {}

func _ready() -> void:
	for child in $npc_spots.get_children():
		npc_spots[child.name.to_lower()] = child
	
	for child in $patient_spots.get_children():
		patient_spots[child.name.to_lower()] = child
	
	GameManager.spawn_patient()
