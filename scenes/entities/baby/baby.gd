class_name Baby extends InteractableComponent

var dna: String = ""
var split_dna: Array = []
var needs: Array = []
var id: int = GameManager.UNASSIGNED
var patient_id: int = GameManager.UNASSIGNED
var is_in_incubator: bool = false

var effect: Dictionary = {
	effect_index = 1,
	intensity = 1.0,
	frequency = 1.0,
	# another one here idk what to put
}

var LETTER_TO_VAL: Dictionary = {
	A = 1,
	C = 2,
	G = 3,
	T = 4
}

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.baby
	
	id = GameManager.latest_baby_id + 1
	GameManager.latest_baby_id += 1
	
	generate_dna()

func generate_dna() -> void: 
	var choices: String = "ACGT"
	var length: int = 16
	
	for i in range(length):
		dna += choices[randi_range(0, choices.length() - 1)]
	
	generate_effects()

func generate_effects() -> void:
	@warning_ignore("integer_division")
	for i in round(dna.length() / 4):
		split_dna.append(dna.substr(i * 4, 4))
	
	# do something here
