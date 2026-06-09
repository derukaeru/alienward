extends Node

var day_configs: Array = []

func _ready() -> void:
	var json = FileAccess.open("res://scripts/data/days.json", FileAccess.READ)
	day_configs = JSON.parse_string(json.get_as_text())

func get_day_config(number: int = -1) -> Dictionary:
	var index = number - 1
	if index < day_configs.size():
		return day_configs[index]
	else:
		return day_configs[-1]
