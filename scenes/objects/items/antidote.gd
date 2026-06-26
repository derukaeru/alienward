class_name Antidote extends BaseAntidoteItem

var data: Dictionary = {
	base = 0,
	intensity = 1.0,
	frequency = 1.0,
	duration = 1.0
}

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.antidote
