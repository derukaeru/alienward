extends CanvasLayer

@onready var fps: Label = $fps
@onready var dirtiness: Label = $dirtiness
@onready var tooltip: RichTextLabel = $tooltip

@onready var guide_patient: ColorRect = $guide_patient

@onready var body: Control = $body
@onready var held_item: Control = $body/held_item

func _process(_delta) -> void:
	if guide_patient.visible:
		if Input.is_action_just_pressed("scroll_up"):
			GameManager.selected_ward_on_ui -= 1
		if Input.is_action_just_pressed("scroll_down"):
			GameManager.selected_ward_on_ui += 1
		
		GameManager.selected_ward_on_ui = clamp(GameManager.selected_ward_on_ui, 0, 3)
		
		for i in range(4):
			if i == GameManager.selected_ward_on_ui:
				get_node("guide_patient/wards/ward_%d" % i).show()
			else:
				get_node("guide_patient/wards/ward_%d" % i).hide()
