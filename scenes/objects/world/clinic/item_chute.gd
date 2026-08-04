extends Node3D

@onready var animation: AnimationPlayer = $ModelContainer/AnimationPlayer

func _ready() -> void:
	EventBus.generate_item.connect(generate_item)

func generate_item(item_id: String) -> void:
	var id: String = ITEMS.IDS[item_id] + "_instance"
	var instance: String = Registry.UID[id]
	
	var item: Item = load(instance).instantiate()
	Util.add_entity_to_container(item)
	
	item.global_position = global_position + Vector3(0.0, -1.5, 0.0)
	
	var particle: GPUParticles3D = load(Registry.particles.item).instantiate()
	add_child(particle)
	
	particle.global_position.y -= 0.5
