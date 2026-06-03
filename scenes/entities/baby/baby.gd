class_name Baby extends InteractableComponent

var needs: Array = []
var baby_id: int = -1

func _ready() -> void:
	baby_id = GameManager.latest_baby_id + 1
	GameManager.latest_baby_id += 1
