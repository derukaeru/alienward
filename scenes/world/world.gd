extends Node3D

@onready var entities: Node3D = $entities

func _ready() -> void:
	EventBus.add_entity_to_container.connect(add_entity)

func add_entity(node: Node) -> void:
	entities.add_child(node)
