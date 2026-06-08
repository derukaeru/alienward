extends CanvasLayer

@onready var fps: Label = $fps
@onready var dirtiness: Label = $dirtiness
@onready var tooltip: RichTextLabel = $tooltip

@onready var guide_patient: ColorRect = $guide_patient

@onready var body: Control = $body
@onready var held_item: Control = $body/held_item

@onready var microscope_screen: Control = $microscope_screen
@onready var shop_screen: Control = $shop_screen

func _process(_delta) -> void:
	if guide_patient.visible:
		if Input.is_action_just_pressed("scroll_up"):
			GameManager.selected_ward_on_ui -= 1
		if Input.is_action_just_pressed("scroll_down"):
			GameManager.selected_ward_on_ui += 1
		
		GameManager.selected_ward_on_ui = clamp(GameManager.selected_ward_on_ui, 0, 3)
