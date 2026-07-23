extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var bacteria_container: Control = $bacteria_container
@onready var dna_display: Control = $dna_display
@onready var identifying_bacteria_bar: ProgressBar = $identifying_bacteria_bar

@onready var bacteria: Resource = load(Registry.UID.bacteria)
@onready var dna_value: TextureRect = $dna_value
@onready var dna_value_label: Label = $dna_value/value
@onready var bacteria_type_label: Label = $dna_value/type

enum LETTERS_TO_VAL { A, C, G, T }
var bacteria_colors: Array = []
var effect_names: Array = ["effect_index", "intensity", "frequency", "duration"]

var IDENTIFY_SPEED: float = 4.4
var identifying_bacteria: Bacteria
@onready var identifying_timer: Timer = $identifying_timer


func _ready() -> void:
	EventBus.create_new_dna.connect(new_dna)
	EventBus.identify_bacteria.connect(identify_bacteria)
	EventBus.show_dna.connect(set_dna_color)

	new_dna()

func new_dna() -> void:
	var split_dna: Array = get_split_dna()
	if not split_dna: return
	for i in range(4):
		var new_bacteria: Bacteria = bacteria.instantiate()
		bacteria_container.add_child(new_bacteria)
		new_bacteria.index = i

		new_bacteria.position.x = randi_range(0, 305)
		new_bacteria.position.y = randi_range(0, 305)

		bacteria_colors.append(generate_chunk_colors(split_dna[i]))
		new_bacteria.modulate = bacteria_colors[i][4]
		new_bacteria.type = new_bacteria.TYPES[i]

func get_split_dna() -> Array:
	var split_dna: Array = []
	var dna: String = GameManager.microscope_dna

	if not dna: return []
	for i in range(4):
		split_dna.append(dna.substr(i * 4, 4))

	return split_dna

func get_baby_with_dna(dna: String) -> Baby:
	for entry in Util.get_group_nodes("baby"):
		if entry.dna == dna:
			return entry
	return null

func set_dna_color(bacteria_index: int) -> void:
	if bacteria_colors[bacteria_index].is_empty(): return
	dna_display.change_dna_display(bacteria_colors[bacteria_index])

	var baby: Baby = get_baby_with_dna(GameManager.microscope_dna)
	if not baby: return

	bacteria_type_label.text = str(effect_names[bacteria_index])
	dna_value_label.text = str(baby.effect[effect_names[bacteria_index]])

func identify_bacteria(_bacteria: Bacteria) -> void:
	if _bacteria.index == GameManager.UNASSIGNED or _bacteria.identified: return

	if not identifying_timer.is_stopped():
		identifying_timer.stop()

	identifying_bacteria_bar.max_value = IDENTIFY_SPEED
	identifying_bacteria_bar.value = identifying_bacteria_bar.max_value - identifying_timer.time_left

	identifying_timer.start(IDENTIFY_SPEED)
	identifying_bacteria = _bacteria

func identified_bacteria() -> void:
	identifying_bacteria_bar.value = 0.0
	set_dna_color(identifying_bacteria.index)

	identifying_bacteria.identified = true
	identifying_bacteria = null

func generate_chunk_colors(chunk: String) -> Array:
	var r: float = LETTERS_TO_VAL[chunk[0]] / 4.0
	var g: float = LETTERS_TO_VAL[chunk[1]] / 4.0
	var b: float = LETTERS_TO_VAL[chunk[2]] / 4.0

	return [
		Color(r, 0.2, 0.2),
		Color(0.2, g, 0.2),
		Color(0.2, 0.2, b),
		Color(r, g, b),
		Color(r, g, b)
	]

func _on_leave_pressed() -> void:
	Util.mouse_captured()

	animation.play_backwards("pop")
	await animation.animation_finished

	hide()
	EventBus.close_microscope.emit()

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return

	if not identifying_timer.is_stopped():
		identifying_bacteria_bar.value = identifying_bacteria_bar.max_value - identifying_timer.time_left

	if Input.is_action_just_pressed("ui_cancel") and player.ui.microscope_open:
		_on_leave_pressed()

func dna_hovered() -> void:
	dna_value.show()

func dna_unhovered() -> void:
	dna_value.hide()

func remove_dna():
	for entry in bacteria_container.get_children():
		entry.queue_free()

	GameManager.microscope_dna = ""
	dna_value_label.text = "no value"
	bacteria_type_label.text = "no type"

	bacteria_colors = []
	identifying_bacteria = null
	identifying_bacteria_bar.value = 0.0

	dna_display.show_dna = false
