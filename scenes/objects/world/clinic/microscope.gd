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
			EventBus.create_new_dna.emit()
			
			var particle: GPUParticles3D = load(Registry.particles.interact).instantiate()
			add_child(particle)
			particle.global_position.y += 1.0
			
			return
		
	animation.play("pop")
	EventBus.open_microscope.emit()
