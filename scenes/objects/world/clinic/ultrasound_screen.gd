extends InteractableComponent

var scanned_patient_id: int = GameManager.UNASSIGNED

func _ready() -> void: 
	tooltip_text = Lang.TOOLTIPS.ultrasound_screen
	EventBus.patient_scanned.connect(
		func(id: int) -> void:
			scanned_patient_id = id
	)

func generate_image(id: int = GameManager.UNASSIGNED) -> void:
	scanned_patient_id = id
	if not scanned_patient_id: return
	
	EventBus.generate_image.emit(scanned_patient_id)
	scanned_patient_id = GameManager.UNASSIGNED

func interact() -> void:
	generate_image(scanned_patient_id)
