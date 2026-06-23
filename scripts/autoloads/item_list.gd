extends Node

# item ids for registry
const IDS: Dictionary = {
	clipboard = "clipboard",
	baby = "baby_sprite",
	swab = "swab_sprite",
	swab_used = "swab_used",
	ultrasound_scanner = "ultrasound_scanner",
	antidote = "antidote",
	mop = "mop",
	chili = "chili",
}

var undroppable: Array = [IDS.clipboard, IDS.baby]
var throwable: Array = [IDS.swab, IDS.swab_used, IDS.antidote]

var ANTIDOTE_ITEMS: Dictionary = {
	
}
