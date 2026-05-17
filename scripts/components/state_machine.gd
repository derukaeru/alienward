class_name StateMachine extends Node

@export var body: Node3D
@export var initial_state: State

var current_state: State
var states:Dictionary = {}

signal state_changed(from, to)

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.body = body
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.call_deferred("enter")
		current_state = initial_state

func _process(_delta) -> void:
	if current_state:
		current_state.update()

func _physics_process(delta) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name) -> void:
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	state_changed.emit(state.name, new_state.name)
