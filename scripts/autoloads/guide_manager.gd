extends Node
var guide_active: bool = true

enum GUIDE_PARTS {
	ASSISTING_PATIENTS,
	SCANNING_PATIENTS,
	GUIDING_LABOR_PATIENTS,
	ATTENDING_TO_BABY,
	PICKING_UP_ITEMS,
	INTERACTING_TO_OBJECTS,
	SETTING_INCUBATOR,
	GIVING_BABY_TO_PATIENT,
	CLEANING_DIRT,
	SWABBING_BABY,
	MAKING_ANTIDOTE,
	GIVING_ANTIDOTE
}
var current_guide: GUIDE_PARTS = GUIDE_PARTS.ASSISTING_PATIENTS

func _ready() -> void:
	pass

func _process(_delta) -> void:
	pass

func activate_guide() -> void:
	pass

func set_guide_text(text: String) -> void:
	EventBus.set_guide_text.emit(text)
