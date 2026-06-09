class_name Microscope extends InteractableComponent

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.microscope

func interact() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == player.ITEMS_ID.swab or player.held_item_id == player.ITEMS_ID.swab_used:
		var id: int = player.held_item.baby_id
		
		if id > -1:
			GameManager.microscope_dna = Util.get_baby_with_id(id).dna
			player.remove_held_item()
			
			return
	
	if player.ui_layer.microscope_open: return
	
	player.ui_layer.open_microscope_screen()
	Util.mouse_visible()
