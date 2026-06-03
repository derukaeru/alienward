extends InteractableComponent

func _on_interacted(_interactor):
	Util.get_player().set_held_item("swab_sprite")
