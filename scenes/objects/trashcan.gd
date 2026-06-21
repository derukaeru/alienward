class_name Trashcan extends InteractableComponent

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.trashcan

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
		
	if player.held_item == null:
		tooltip_text = Lang.TOOLTIPS.trashcan
	elif player.raycast.get_collider() == self and not player.throwable.has(player.held_item_id):
		tooltip_text = Lang.TOOLTIPS.trashcan_reject
	else:
		tooltip_text = Lang.TOOLTIPS.trashcan_throw

func _on_interacted() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.throwable.has(player.held_item_id):
		player.remove_held_item()
