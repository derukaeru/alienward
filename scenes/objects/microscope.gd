class_name Microscope extends InteractableComponent

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.microscope

func interact() -> void:
	var player: CharacterBody3D = Util.get_player()
	if (player.held_item_id == player.ITEMS_ID.swab) or (player.held_item_id == player.ITEMS_ID.swab_used):
		var id: int = player.held_item.baby_id
		
		if id > -1:
			GameManager.microscope_dna = Util.get_baby_with_id(id).dna
			player.remove_held_item()
			
			return
	
	if GameManager.microscope_open: return
	
	GameManager.open_microscope_screen()
	Util.mouse_visible()
