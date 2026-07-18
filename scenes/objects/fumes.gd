extends Area3D

var duration: int = 20
var bodies: Array = []

func _ready() -> void:
	#get_tree().create_timer(duration).timeout.connect(end)
	pass

func _process(_delta) -> void:
	var coll: Array = get_overlapping_bodies()
	for entry in bodies:
		if coll.has(entry):
			if entry.hallucinogen:
				entry.hallucinogen = false

	for entry in coll:
		if !bodies.has(entry) and entry is Player:
			bodies.append(entry)
			
			entry.hallucinogen = true

func end() -> void:
	for entry in bodies: 
		entry.hallucinogen = false
	
	queue_free()
