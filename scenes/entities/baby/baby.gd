class_name Baby extends InteractableComponent

var dna: String = ""
var needs: Array = []
var id: int = -1

func _ready() -> void:
	id = GameManager.latest_baby_id + 1
	GameManager.latest_baby_id += 1
	
	generate_dna()

func generate_dna(): 
	var choices: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	var length: int = 12
	
	for i in range(length):
		dna.join([choices[randi_range(0, choices.length() - 1)]])
