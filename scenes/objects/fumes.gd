extends Area3D

var duration: int = 20
func _ready() -> void:
	get_tree().create_timer(duration).timeout.connect(queue_free)

func _process(_delta) -> void:
	var coll: Array = get_overlapping_areas()
	for entry in coll:
		if entry is Player:
			entry.hallucinogen = true
