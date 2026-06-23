class_name Baby extends Item

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

var dna: String = ""
var split_dna: Array = []
var needs: Array = []
var id: int = GameManager.UNASSIGNED
var patient_id: int = GameManager.UNASSIGNED

var is_in_delivery_table: bool = false
var delivery_table: DeliveryTable

var is_in_incubator: bool = false
var incubator: Incubator

var showing_symptoms: bool = false
var time_to_show_symptoms: float = 10.0

enum LETTER_TO_VAL {A, C, G, T}
var effect: Dictionary = {
	effect_index = 1,
	intensity = 1.0,
	frequency = 1.0,
	duration = 1.0,
}

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.baby
	
	id = GameManager.latest_baby_id + 1
	GameManager.latest_baby_id += 1
	
	generate_dna()
	
	get_tree().create_timer(time_to_show_symptoms).timeout.connect(
		func(): 
			showing_symptoms = true
			get_tree().create_timer(effect.duration).timeout.connect(activate_effect)
	)

func _process(_delta) -> void:
	if is_in_delivery_table: 
		pass
	elif is_in_incubator:
		pass

func generate_dna() -> void: 
	var choices: String = "ACGT"
	var length: int = 16
	
	for i in range(length):
		dna += choices[randi_range(0, choices.length() - 1)]
	
	generate_effect()

func get_split_dna(full_dna: String = dna) -> Array:
	var chunk_array: Array = []
	
	for i in range(4):
		chunk_array.append(full_dna.substr(i * 4, 4))
	
	return chunk_array

func generate_effect() -> void:
	split_dna = get_split_dna()
	
	# effect type
	var effects_num = EffectsManager.EFFECTS.size()
	var dna_chunk_one: String = split_dna[0]
	var chunk_one_total: int = 0
	
	for i in range(len(dna_chunk_one)):
		chunk_one_total += round(LETTER_TO_VAL[dna_chunk_one[i]] * i)
	effect.effect_index = remap(chunk_one_total, 0, 48, 0, effects_num)
	
	# intensity
	var dna_chunk_two: String = split_dna[1]
	var chunk_two_total: float = 0.0
	
	match dna_chunk_two[0]:
		"A": chunk_two_total = 0.5
		"C": chunk_two_total = 1.0
		"G": chunk_two_total = 1.5
		"T": chunk_two_total = 2.0
	
	for i in range(1, 3):
		chunk_two_total += LETTER_TO_VAL[dna_chunk_two[i]] * 0.2
	effect.intensity = remap(chunk_two_total, 0.0, 3.0, 0.5, 2.0)
	
	# frequency
	var dna_chunk_three: String = split_dna[2]
	var chunk_three_total: float = 0.0
	
	match dna_chunk_three[0]:
		"A": chunk_three_total = 0.5
		"C": chunk_three_total = 1.0
		"G": chunk_three_total = 1.5
		"T": chunk_three_total = 2.0
	
	for i in range(1, 3):
		chunk_three_total += LETTER_TO_VAL[dna_chunk_three[i]] * 0.2
	effect.intensity = remap(chunk_three_total, 0.0, 3.0, 0.5, 2.0)
	
	# duration
	var dna_chunk_four: String = split_dna[2]
	var chunk_four_total: float = 0.0
	
	match dna_chunk_four[0]:
		"A": chunk_four_total = 0.5
		"C": chunk_four_total = 1.0
		"G": chunk_four_total = 1.5
		"T": chunk_four_total = 2.0
	
	for i in range(1, 3):
		chunk_four_total += LETTER_TO_VAL[dna_chunk_four[i]] * 0.2
	effect.intensity = remap(chunk_four_total, 0.0, 3.0, 0.5, 2.0)

func activate_effect() -> void:
	EffectsManager.apply_effect(self, effect)

func pick_up() -> void:
	if incubator:
		incubator.incubated_baby = null
		incubator = null
		is_in_incubator = false
	
	if delivery_table:
		delivery_table.held_baby = null
		delivery_table.change_tooltip()
		
		delivery_table = null
		is_in_delivery_table = false

func give_antidote(antidote: BaseAntidoteItem) -> void:
	pass
