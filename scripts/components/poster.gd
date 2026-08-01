class_name Poster extends InteractableComponent

@export var poster_name: String = ""

func _ready() -> void:
	interacted.connect(_on_interacted)
	show_tooltip_text = true
	tooltip_text = "poster"

func _on_interacted() -> void:
	GameManager.ui.open_poster(poster_name)
