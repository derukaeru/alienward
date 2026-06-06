class_name Trashcan extends InteractableComponent

func _process(_delta) -> void:
	var player: CharacterBody3D = Util.get_player()
	
	if player.held_item == null:
		show_tooltip_text = false
	else:
		show_tooltip_text = true

func _on_interacted() -> void:
	var player: CharacterBody3D = Util.get_player()
	if player.held_item_id == player.ITEMS_ID.baby or player.held_item_id == player.ITEMS_ID.clipboard:
		return
	
	player.remove_held_item()
