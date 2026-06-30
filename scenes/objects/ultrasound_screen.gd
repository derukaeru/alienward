extends InteractableComponent

var scanned_patient_id: int = GameManager.UNASSIGNED

func _ready() -> void: 
	tooltip_text = Lang.TOOLTIPS.ultrasound_screen
	EventBus.patient_scanned.connect(generate_image)

func generate_image(id: int = -1) -> void:
	scanned_patient_id = id
	if not scanned_patient_id: return
	
	EventBus.generate_image.emit(scanned_patient_id)
	scanned_patient_id = -1

func interact() -> void:
	generate_image()
