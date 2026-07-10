extends Node

const TOOLTIPS: Dictionary = {
	# items
	baby = "baby",
	swab = "swab",
	swab_used = "used swab",
	mop = "mop",
	antidote = "antidote",
	chili = "chili",
	
	# misc.
	shop = "open shop",
	microscope = "open microscope",
	antidote_stand = "antidote stand",
	swab_container = "get swab",
	printer = "printer",
	
	trashcan = "trash can",
	trashcan_throw = "throw item",
	trashcan_reject = "cannot throw item",
	
	incubator = "place baby",
	incubator_normal = "incubator",
	incubator_baby = "pick up",
	incubator_occupied = "this is occupied",
	
	ultrasound_screen = "ultrasound screen",
	ultrasound_scanner = "ultrasound scanner",
	ultrasound_print = "ultrasound photo",
	
	delivery_table = "delivery table",
	delivery_table_baby = "pick up baby",
}

const WARNINGS: Dictionary = {
	drop_baby = "Please put the baby at a safe place",
	throw_item = "You cannot throw the item you're holding",
	pick_up_baby = "Place down the baby first",
	incubator_occupied = "This incubator is occupied"
}

const subtitles: Dictionary = {
	guide_patient = "guided patient",
	cleaned_mop = "cleaned mop",
	scanned_patient = "scanned patient",
	generated_print = "generated print",
	gave_antidote = "gave antidote",
}
