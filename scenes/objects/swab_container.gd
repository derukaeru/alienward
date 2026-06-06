class_name SwabContainer extends InteractableComponent

func _on_interacted() -> void:
	var player: CharacterBody3D = Util.get_player()
	if player.held_item_id != player.ITEMS_ID.clipboard: return
	
	var _swab: InteractableComponent = load(Registry.UID["swab"]).instantiate()
	Util.get_group_node("entities_container").add_child(_swab)
	_swab.name = "swab"
	player.pick_up(_swab)
