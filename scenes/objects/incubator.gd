class_name Incubator extends InteractableComponent

func interact() -> void:
	var player: CharacterBody3D = Util.get_player()
	
	player.held_item.global_position = global_position + Vector3(0.0, 0.8, 0.0)
	player.held_item.set_collision_layer_value(1, true)
	
	player.held_item.show()
	player.held_item = null
	
	player.set_held_item_sprite("clipboard")
