extends InteractableComponent

func interact() -> void:
	if GameManager.microscope_open: return
	
	GameManager.open_microscope_screen()
	Util.mouse_visible()
