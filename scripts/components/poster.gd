class_name Poster extends InteractableComponent

@export var poster_name: String = ""

func _on_interacted() -> void:
	GameManager.ui.open_poster(poster_name)
