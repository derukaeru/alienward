extends CanvasLayer

@onready var fps: Label = $fps
@onready var dirtiness: Label = $dirtiness
@onready var tooltip: RichTextLabel = $tooltip

@onready var guide_patient: ColorRect = $guide_patient
@onready var checkup: ColorRect = $checkup

@onready var body: Control = $body
@onready var held_item: Control = $body/held_item
@onready var hand: Control = $body/hand

@onready var microscope_screen: Control = $microscope_screen
@onready var shop_screen: Control = $shop_screen

var microscope_open: bool = false
var shop_open: bool = false
var patient_open: bool = false

func _input(event) -> void:
	if guide_patient.visible:
		if event is InputEventMouseButton and event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					GameManager.selected_ward_on_ui -= 1
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					GameManager.selected_ward_on_ui += 1
				
				GameManager.selected_ward_on_ui = clamp(GameManager.selected_ward_on_ui, 0, 3)
				
				for i in range(4):
					get_node("guide_patient/ward_%d" % i).hide()
				
				get_node("guide_patient/ward_%d" % GameManager.selected_ward_on_ui).show()

func open_patient_screen(reason: GameManager.REASONS) -> void:
	if patient_open: return
	
	match reason:
		GameManager.REASONS.LABOR: guide_patient.show()
		GameManager.REASONS.CHECKUP: checkup.show()
	
	patient_open = true

func open_shop_screen() -> void:
	if shop_open: return
	
	var player = Util.get_player()
	if not player: return
	
	shop_screen.show()
	shop_open = true
	
	player.can_move = false
	player.velocity = Vector3.ZERO

func open_microscope_screen() -> void:
	if microscope_open: return
	
	var player = Util.get_player()
	if not player: return
	
	microscope_screen.show()
	microscope_open = true
	
	player.can_move = false
	player.velocity = Vector3.ZERO

func show_tooltip(text: String) -> void:
	tooltip.text = text
	
	set_hand_sprite()

func hide_tooltip() -> void:
	tooltip.text = ""
	
	var player: Player = Util.get_player()
	if not player: return
	
	set_hand_sprite()

func set_hand_sprite() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.held_item_id == player.ITEMS_ID.clipboard and tooltip.text != "":
		hand.texture = load(Registry.UID["hand_point"])
		held_item.hide()
	else:
		hand.texture = load(Registry.UID["hand_hold"])
		held_item.show()
