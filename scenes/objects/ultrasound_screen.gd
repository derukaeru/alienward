extends InteractableComponent

var scanned_patient_id: int = GameManager.UNASSIGNED

func _ready() -> void: 
	tooltip_text = Lang.TOOLTIPS.ultrasound_screen

func generate_image() -> void:
	if not scanned_patient_id: return
	EventBus.generate_image.emit(scanned_patient_id)

func interact() -> void:
	generate_image()
