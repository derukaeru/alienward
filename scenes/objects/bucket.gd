extends InteractableComponent

func interact() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == ITEMS.IDS.mop:
		player.held_item.dirtiness = 0.0
