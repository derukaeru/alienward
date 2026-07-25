class_name StatusBubble extends Node3D

@onready var sprite: Sprite3D = $Sprite3D
var status_type: String = ""

func _ready() -> void:
	if not status_type: return
	if not Registry.UID.has(status_type): 
		print("this status type is not in the Registry: " + status_type)
		return
	
	sprite.texture = load(Registry.UID[status_type])
