extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var bacteria_container: Control = $bacteria_container
@onready var bacteria: Resource = load(Registry.UID["bacteria"])

func _ready() -> void: 
	new_dna()

func new_dna() -> void:
	var split_dna: Array = []
	var dna: String = GameManager.microscope_dna
	
	for i in range(4):
		split_dna.append(dna.substr(i * 4, 4))
	
	for i in range(4):
		var new_bacteria: Bacteria = bacteria.instantiate()
		bacteria_container.add_child(new_bacteria)
		
		new_bacteria.position.x = randi_range(0, 305)
		new_bacteria.position.y = randi_range(0, 305)
		
		# TODO: determine color using split dna chunks
		# TODO: determine dna base pair colors in dna_display (COLORS: Dictionary)

func set_dna_color(bacteria_index: int) -> void:
	pass

func _on_leave_pressed() -> void:
	Util.mouse_captured()
	
	animation.play_backwards("pop")
	await animation.animation_finished
	
	hide()
	
	var player: Player = Util.get_player()
	if not player: return
	
	player.ui_layer.microscope_open = false
	player.can_move = true
	
func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if Input.is_action_just_pressed("ui_cancel") and player.ui_layer.microscope_open:
		_on_leave_pressed()
