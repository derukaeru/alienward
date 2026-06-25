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
}

var undroppable: Array = [IDS.clipboard, IDS.baby]
var throwable: Array = [IDS.swab, IDS.swab_used, IDS.antidote]

# item instances ids for registry autoload
var SHOP_ITEMS: Dictionary = {
	chili = "chili_instance"
}
