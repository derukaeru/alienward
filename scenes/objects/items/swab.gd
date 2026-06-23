class_name Swab extends Item

var baby_id: int = GameManager.UNASSIGNED

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.swab

func use(id: int) -> void:
	baby_id = id
	internal_name = "swab_used"
	tooltip_text = Lang.TOOLTIPS.swab_used
