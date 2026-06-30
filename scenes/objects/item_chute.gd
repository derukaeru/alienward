extends Node3D

@onready var animation: AnimationPlayer = $ModelContainer/AnimationPlayer

func _ready() -> void:
	EventBus.generate_item.connect(generate_item)

func generate_item(item_id: String) -> void:
	var item: Item = load(Registry.UID[ITEMS.SHOP_ITEMS[item_id]]).instantiate()
	Util.add_entity_to_container(item)
	
	item.global_position = global_position + Vector3(0.0, -1.5, 0.0)
