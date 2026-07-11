extends Node

# item ids for registry
const IDS: Dictionary = {
	clipboard = "clipboard",
	baby = "baby_sprite",
	swab = "swab_sprite",
	swab_used = "swab_used",
	ultrasound_scanner = "ultrasound_scanner",
	ultrasound_print = "ultrasound_print",
	antidote = "antidote",
	mop = "mop",
	
	chili = "chili",
	ink_sac = "ink_sac",
	ginger = "ginger",
	coffee_bean = "coffee_bean",
}

var undroppable: Array = [IDS.clipboard, IDS.baby]
var nonthrowable: Array = [IDS.clipboard, IDS.mop, IDS.ultrasound_scanner, IDS.baby]
var unmovable: Array = [IDS.ultrasound_scanner, IDS.mop]

enum ANTIDOTE_BASE_INDICES {
	ginger,
	ink_sac,
	chili,
	coffee_bean
}
