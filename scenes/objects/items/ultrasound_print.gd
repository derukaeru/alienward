extends Item

var patient_id: int = GameManager.UNASSIGNED

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.ultrasound_print
