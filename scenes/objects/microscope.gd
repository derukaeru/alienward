extends InteractableComponent

func interact() -> void:
	var player = Util.get_player()
	if player.held_item_id == player.ITEMS_ID.swab:
		var id: int = player.held_item.baby_id
		
		if id > -1:
			GameManager.microscope_dna = Util.get_baby_with_id(id).dna
			player.remove_held_item()
			
			return
	
	if GameManager.microscope_open: return
	
	GameManager.open_microscope_screen()
	Util.mouse_visible()
