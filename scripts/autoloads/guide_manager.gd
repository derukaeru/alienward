extends Node
var guide_active: bool = true

enum GUIDE_PARTS {
	WELCOME_TO_GAME,
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
var last_guide: GUIDE_PARTS = GUIDE_PARTS.WELCOME_TO_GAME
var current_guide: GUIDE_PARTS = GUIDE_PARTS.WELCOME_TO_GAME
var current_guide_chunk_index: int = 0

func _ready() -> void:
	EventBus.player_spawned.connect(activate_guide)

func _process(_delta) -> void:
	if not guide_active: return

func activate_guide() -> void:
	guide_active = true
	current_guide_chunk_index = 0
	EventBus.activated_guide.emit()
	
	match current_guide:
		GUIDE_PARTS.WELCOME_TO_GAME:
			if GameManager.current_day != 0: return
			
			
		GUIDE_PARTS.ASSISTING_PATIENTS:
			pass
		GUIDE_PARTS.SCANNING_PATIENTS:
			pass
		GUIDE_PARTS.GUIDING_LABOR_PATIENTS:
			pass
		GUIDE_PARTS.ATTENDING_TO_BABY:
			pass
		GUIDE_PARTS.PICKING_UP_ITEMS:
			pass
		GUIDE_PARTS.INTERACTING_TO_OBJECTS:
			pass
		GUIDE_PARTS.SETTING_INCUBATOR:
			pass
		GUIDE_PARTS.SETTING_INCUBATOR:
			pass
		GUIDE_PARTS.GIVING_BABY_TO_PATIENT:
			pass
		GUIDE_PARTS.CLEANING_DIRT:
			pass
		GUIDE_PARTS.SWABBING_BABY:
			pass
		GUIDE_PARTS.MAKING_ANTIDOTE:
			pass
		GUIDE_PARTS.GIVING_ANTIDOTE:
			pass

func set_guide_text(text: String) -> void:
	EventBus.set_guide_text.emit(text)

func cancel_guide() -> void:
	guide_active = false
	EventBus.canceled_guide.emit()
