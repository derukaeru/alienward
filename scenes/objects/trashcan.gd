class_name Trashcan extends InteractableComponent

@onready var animation: AnimationPlayer = $ModelContainer/AnimationPlayer

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.trashcan

func _process(_delta) -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item == null:
		tooltip_text = Lang.TOOLTIPS.trashcan
	else:
		tooltip_text = Lang.TOOLTIPS.trashcan_throw

func _on_interacted() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.throwable.has(player.held_item_id):
		player.remove_held_item()
		animation.play("pop")
	elif player.held_item_id != ITEMS.ID.clipboard:
		player.ui_layer.show_warning(Lang.WARNINGS.throw_item)
