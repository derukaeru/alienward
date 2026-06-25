extends InteractableComponent

var scanned_patient_id: int = GameManager.UNASSIGNED

func _ready() -> void: 
	tooltip_text = Lang.TOOLTIPS.ultrasound_screen
	
	scanned_patient_id = 1

func generate_image() -> void:
	var printer: InteractableComponent = Util.get_group_node("printer")
	
	if not scanned_patient_id or printer.printing or printer.printed: return
	printer.print_ultrasound()

func interact() -> void:
	generate_image()
