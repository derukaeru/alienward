class_name Baby extends InteractableComponent

var dna: String = ""
var needs: Array = []
var id: int = -1
var patient_id: int = -1
var is_in_incubator: bool = false

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.baby
	
	id = GameManager.latest_baby_id + 1
	GameManager.latest_baby_id += 1
	
	generate_dna()

func generate_dna() -> void: 
	var choices: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	var length: int = 12
	
	for i in range(length):
		dna.join([choices[randi_range(0, choices.length() - 1)]])
