extends Node3D

@onready var entities: Node3D = $entities

func _ready() -> void:
	EventBus.add_entity_to_container.connect(add_entity)
	GameManager.ui.show()
	
	GameManager.start_day()
	
	GameManager.spawn_patient()
	await get_tree().create_timer(1.0).timeout
	GameManager.spawn_patient()

func add_entity(node: Node) -> void:
	entities.add_child(node)

func _process(_delta) -> void:
	if GameManager.day_going:
		if GameManager.patient_queue > 0:
			for i in range(GameManager.patient_queue):
				GameManager.spawn_patient()
	
	
