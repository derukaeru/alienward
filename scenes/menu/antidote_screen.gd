extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var base_container: Control = $base_container

@onready var frequency_value_label: Label = $frequency_value
@onready var intensity_value_label: Label = $intensity_value
@onready var duration_value_label: Label = $duration_value
@onready var base_warning: Label = $base_warning

var antidote_data: Dictionary = {
	base = -1,
	intensity = 1.0,
	frequency = 1.0,
	duration = 1.0,
}

func leave() -> void:
	Util.mouse_captured()
	
	animation.play_backwards("pop")
	await animation.animation_finished
	
	hide()
	
	var player: Player = Util.get_player()
	if not player: return
	
	player.ui_layer.antidote_open = false
	player.can_move = true

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if Input.is_action_just_pressed("ui_cancel") and player.ui_layer.antidote_open:
		leave()

func opened() -> void:
	var antidote_stand: InteractableComponent = Util.get_group_node("antidote_stand")
	if not antidote_stand: return
	
	
	for entry in base_container.get_children():
		entry.queue_free()
	base_warning.show()
	
	if not antidote_stand.base_antidote_name: return
	
	var base_item_name: String = antidote_stand.base_antidote_name
	var base_item_sprite: TextureRect = TextureRect.new()
	base_item_sprite.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	
	base_item_sprite.texture = load(Registry.UID[base_item_name])
	base_container.add_child(base_item_sprite)
	base_warning.hide()
	
	antidote_data.base = ITEMS.ANTIDOTE_BASE_INDICES[base_item_name]

func change_frequency_value(value: float) -> void:
	antidote_data.frequency = clamp(antidote_data.frequency + value, 0.0, 2.0)
	frequency_value_label.text = str(antidote_data.frequency)

func change_intensity_value(value: float) -> void:
	antidote_data.intensity = clamp(antidote_data.intensity + value, 0.0, 2.0)
	intensity_value_label.text = str(antidote_data.intensity)

func change_duration_value(value: float) -> void:
	antidote_data.duration = clamp(antidote_data.duration + value, 0.0, 2.0)
	duration_value_label.text = str(antidote_data.duration)

func generate_antidote() -> void:
	var antidote_stand: InteractableComponent = Util.get_group_node("antidote_stand")
	if not antidote_stand: return
	
	if not antidote_stand.base_antidote_name: return
	
	# remove base antidote item in screen
	for entry in base_container.get_children():
		entry.queue_free()
		
	antidote_stand.generate_antidote(antidote_data)
	antidote_data = {
		base = -1,
		intensity = 1.0,
		frequency = 1.0,
		duration = 1.0,
	}
	
	change_frequency_value(0)
	change_intensity_value(0)
	change_duration_value(0)
