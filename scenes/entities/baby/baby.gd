class_name Baby extends Item
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

var dna: String = ""
var split_dna: Array = []
var id: int = GameManager.UNASSIGNED

var is_in_delivery_table: bool = false
var delivery_table: DeliveryTable

var is_in_incubator: bool = false
var incubator: Incubator

var held: bool = false

enum LETTER_TO_VAL {A, C, G, T}
var is_cured: bool = false
var effect: Dictionary = {
	effect_index = 1,
	intensity = 1.0,
	frequency = 1.0,
	duration = 1.0,
}
var is_incubated: bool = false
var default_incubate_timer: float = 120.0
var incubate_timer: float = default_incubate_timer

var minimum_effect_timer: float = 14.0
var effect_timer: float = minimum_effect_timer
var can_activate_effect: bool = true

var default_uncomfy_timer: float = 28.0
var uncomfy_timer: float = default_uncomfy_timer
var uncomfy: bool = false

var demanded_temperature: float = 1.0
enum STATES {
	SLEEPING,
	RUCKUS, # baby is activating the effect
	CRYING # baby is either too hot or too cold
}
var state: STATES = STATES.SLEEPING

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.baby

	id = GameManager.latest_baby_id + 1
	GameManager.latest_baby_id += 1

	generate_dna()

	# the lowest the frequency can go is once every 14s
	# 2.0 in effect.frequency means most frequent and 0.1 is least frequent
	effect_timer = 10 * (2.0 - effect.frequency) + minimum_effect_timer

func _process(delta) -> void:
	if is_in_delivery_table:
		held = false
	elif is_in_incubator:
		held = false
		
		if state == STATES.SLEEPING:
			if !is_incubated and !uncomfy:
				incubate_timer -= delta
				
				if incubate_timer <= 0:
					is_incubated = true
			
			if uncomfy:
				if incubator.temperature == demanded_temperature:
					uncomfy = false
					uncomfy_timer = default_uncomfy_timer
	elif held:
		var player: Player = Util.get_player()
		if not player: return
		global_position = player.global_position
	
	if can_activate_effect:
		if effect_timer > -1:
			effect_timer -= delta
	
	if effect_timer <= 0:
		can_activate_effect = false
		effect_timer = 0
		
		activate_effect()
	
	if not uncomfy:
		uncomfy_timer -= delta
		
		if uncomfy_timer <= 0:
			demanded_temperature = randf_range(0.1, 1.9)
			uncomfy = true
	

func activate_effect() -> void:
	EffectsManager.apply_effect(self)
	state = STATES.RUCKUS

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

	held = true

func give_antidote(antidote: BaseAntidoteItem) -> void:
	if is_cured: return
	
	if antidote.data.duration != effect.duration or antidote.data.frequency != effect.frequency or antidote.data.intensity != effect.intensity: 
		wrong_antidote()
		return
	
	if effect.type == antidote.data.type:
		effect.type = -1
		is_cured = true
		right_antidote()

func right_antidote() -> void:
	pass

func wrong_antidote() -> void:
	pass

func set_effect_activation() -> void:
	can_activate_effect = true
	effect_timer = 100 - (2.0 - effect.frequency) + minimum_effect_timer

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
		chunk_one_total += round(LETTER_TO_VAL[dna_chunk_one[i]] * (i + 1))
	effect.effect_index = int(round(remap(chunk_one_total, 0, 30, 0, effects_num)))

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
	effect.intensity = snapped(remap(chunk_two_total, 0.0, 3.0, 0.5, 2.0), 0.1)

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
	effect.frequency = snapped(remap(chunk_three_total, 0.0, 3.0, 0.5, 2.0), 0.1)

	# duration
	var dna_chunk_four: String = split_dna[3]
	var chunk_four_total: float = 0.0

	match dna_chunk_four[0]:
		"A": chunk_four_total = 0.5
		"C": chunk_four_total = 1.0
		"G": chunk_four_total = 1.5
		"T": chunk_four_total = 2.0

	for i in range(1, 3):
		chunk_four_total += LETTER_TO_VAL[dna_chunk_four[i]] * 0.2
	effect.duration = snapped(remap(chunk_four_total, 0.0, 3.0, 0.5, 2.0), 0.1)
