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
	EventBus.throw_item.emit()
	animation.play("pop")
