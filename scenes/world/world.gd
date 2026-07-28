extends Node3D

@onready var entities: Node3D = $entities

func _ready() -> void:
	EventBus.add_entity_to_container.connect(add_entity)
	GameManager.ui.show()
	GameManager.start_day()
	
	get_tree().create_timer(0.0).timeout.connect(
		func() -> void:
			EventBus.player_spawned.emit()
			EventBus.player_can_move.emit()
	)
	
	EventBus.set_ward_timer.connect(
		func(index: int, time: float) -> void:
			var displayed_text: String
			
			if int(time) <= 0:
				displayed_text = "resting..."
			else:
				displayed_text = str(int(time)) + "s"
			
			get_node("ward_timer_" + str(index)).text = displayed_text
	)

func add_entity(node: Node) -> void:
	entities.add_child(node)

func _process(_delta) -> void:
	if GameManager.day_going:
		if GameManager.patient_queue > 0:
			for i in range(GameManager.patient_queue):
				GameManager.spawn_patient()
