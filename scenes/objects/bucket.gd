extends InteractableComponent

func interact() -> void:
	EventBus.clean_mop.emit()
