class_name Baby extends InteractableComponent

var dna: String = ""
var needs: Array = []
var id: int = GameManager.UNASSIGNED
var patient_id: int = GameManager.UNASSIGNED
var is_in_incubator: bool = false

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.baby
	
	id = GameManager.latest_baby_id + 1
	GameManager.latest_baby_id += 1
	
	generate_dna()

func generate_dna() -> void: 
	var choices: String = "AGCT"
	var length: int = 15
	
	for i in range(length):
		dna += choices[randi_range(0, choices.length() - 1)]
