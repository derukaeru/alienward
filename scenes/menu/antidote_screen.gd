extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var base_container: Control = $base_container

@onready var effect_index_label: Label = $effect_index
@onready var frequency_value_label: Label = $frequency_value
@onready var intensity_value_label: Label = $intensity_value
@onready var duration_value_label: Label = $duration_value

var antidote_data: Dictionary = {
	effect_index = 0,
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
	if not antidote_stand.base_antidote_name: return
	
	var base_item_name: String = antidote_stand.base_antidote_name
	var base_item_sprite: TextureRect = TextureRect.new()
	base_item_sprite.texture = load(Registry.UID[base_item_name])
	
	for entry in base_container.get_children():
		entry.queue_free()
	base_container.add_child(base_item_sprite)

func change_effect_index(value: int) -> void:
	antidote_data.effect_index = clamp(antidote_data.effect_index + value, 0, 9)
	effect_index_label.text = str(antidote_data.effect_index)

func change_frequency_value(value: float) -> void:
	antidote_data.frequency = clamp(antidote_data.frequency + value, 0.0, 2.0)
	frequency_value_label.text = str(antidote_data.frequency)

func change_intensity_value(value: float) -> void:
	antidote_data.intensity = clamp(antidote_data.intensity + value, 0.0, 2.0)
	intensity_value_label.text = str(antidote_data.intensity)

func change_duration_value(value: float) -> void:
	antidote_data.duration = clamp(antidote_data.duration + value, 0.0, 2.0)
	duration_value_label.text = str(antidote_data.duration)
