class_name Microscope extends InteractableComponent

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.microscope

func interact() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == ITEMS.IDS.swab or player.held_item_id == ITEMS.IDS.swab_used:
		var id: int = player.held_item.baby_id
		
		if id > -1:
			GameManager.microscope_dna = Util.get_baby_with_id(id).dna
			player.remove_held_item()
			
			animation.play("pop")
			player.ui_layer.microscope_screen.new_dna()
			
			return
		
	animation.play("pop")
	if player.ui_layer.microscope_open: return
	player.ui_layer.open_microscope_screen()
