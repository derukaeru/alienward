extends CanvasLayer

@onready var fps: Label = $fps
@onready var dirtiness: Label = $dirtiness
@onready var tooltip: RichTextLabel = $tooltip

@onready var guide_patient: ColorRect = $guide_patient

@onready var body: Control = $body
@onready var held_item: Control = $body/held_item

@onready var microscope_screen: Control = $microscope_screen
@onready var shop_screen: Control = $shop_screen

func _input(event) -> void:
	if guide_patient.visible:
		if event is InputEventMouseButton and event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					GameManager.selected_ward_on_ui -= 1
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					GameManager.selected_ward_on_ui += 1
				
				GameManager.selected_ward_on_ui = clamp(GameManager.selected_ward_on_ui, 0, 3)
				print(GameManager.selected_ward_on_ui)
				for i in range(4):
					get_node("guide_patient/wards/ward_%d" % i).hide()
				get_node("guide_patient/wards/ward_%d" % GameManager.selected_ward_on_ui).show()
