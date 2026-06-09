class_name Trashcan extends InteractableComponent

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.trashcan

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item == null:
		show_tooltip_text = false
	else:
		show_tooltip_text = true

func _on_interacted() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == player.ITEMS_ID.baby or player.held_item_id == player.ITEMS_ID.clipboard:
		return
	
	player.remove_held_item()
