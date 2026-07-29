extends CanvasLayer

@onready var fps: Label = $fps
@onready var dirtiness: Label = $dirtiness
@onready var tooltip: RichTextLabel = $tooltip

@onready var guide_patient: ColorRect = $guide_patient
@onready var patient_wards: Array = guide_patient.get_children()

@onready var checkup: ColorRect = $checkup
@onready var no_ward_label: Label = $guide_patient/no_ward

@onready var incubator_screen: Control = $incubator_screen

@onready var body: Control = $body
@onready var held_item: Control = $body/held_item
@onready var hand: Control = $body/hand

@onready var microscope_screen: Control = $microscope_screen
@onready var shop_screen: Control = $shop_screen
@onready var antidote_screen: Control = $antidote_screen

@onready var cleaning_progress: ProgressBar = $cleaning_progress
@onready var subtitle_container: Control = $subtitle_container
@onready var temperature_label: Label = $incubator_screen/temperature

@onready var guide_container: ColorRect = $guide
@onready var guide_text_label: Label = $guide/text

@onready var clock_hand: TextureRect = $clock/hand
@onready var interact_icon: TextureRect = $interact_icon

var microscope_open: bool = false
var shop_open: bool = false
var antidote_open: bool = false

var patient_open: bool = false
var patient: Patient

var showing_warning: bool = false
var warning_timer: Timer
var warning_timer_speed: float = 3.0

var incubator_open: bool = false
var incubator: Incubator
var temperature: float = 1.0

var guide_text: String = ""
var guide_text_index: int = 0
var guide_text_active: bool = false
var guide_text_speed: float = 0.2

var poster_open: bool = false

func _ready() -> void:
	EventBus.open_shop.connect(open_shop_screen)
	EventBus.open_antidote_stand.connect(open_antidote_screen)
	EventBus.open_microscope.connect(open_microscope_screen)
	EventBus.open_incubator_screen.connect(open_incubator_screen)

	EventBus.close_antidote_stand.connect(close_antidote_screen)
	EventBus.close_microscope.connect(close_microscope_screen)
	EventBus.close_shop.connect(close_shop_screen)

	EventBus.done_cleaning.connect(func() -> void: cleaning_progress.hide())
	EventBus.open_patient_screen.connect(open_patient_screen)

	EventBus.add_subtitle.connect(add_subtitle)

func _process(_delta):
	if GameManager.day_going:
		var degrees = remap(GameManager.time, 0, GameManager.DEFAULT_TIME_LENGTH, 90, -270)
		clock_hand.rotation_degrees = degrees

func _input(event: InputEvent) -> void:
	if guide_patient.visible:
		for entry in patient_wards:
			entry.hide()

		if GameManager.selected_ward_on_ui > GameManager.UNASSIGNED:
			patient_wards[GameManager.selected_ward_on_ui].show()

		if not GameManager.ward_occupation.has(false):
			no_ward_label.show()
			return

		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					GameManager.selected_ward_on_ui = Util.get_next_available_ward(GameManager.selected_ward_on_ui, -1)
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					GameManager.selected_ward_on_ui = Util.get_next_available_ward(GameManager.selected_ward_on_ui, 1)
			elif not event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
				guide_patient.hide()
				
				patient_open = false
				patient.guide()
				
				patient = null
	
	if checkup.visible:
		if event is InputEventMouseButton:
			if not event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
				checkup.hide()
				
				patient_open = false
				patient.guide()
				
				patient = null
	
	if incubator_open:
		temperature_label.text = str(temperature)
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					temperature -= 0.1
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					temperature += 0.1
			elif not event.is_pressed():
				close_incubator_screen()

func open_patient_screen(p: Patient) -> void:
	if patient_open or not p: return
	patient = p
	interact_icon.hide()
	
	match patient.reason:
		GameManager.REASONS.LABOR: guide_patient.show()
		GameManager.REASONS.CHECKUP: checkup.show()

	patient_open = true

func open_shop_screen() -> void:
	if shop_open: return

	shop_screen.show()
	shop_open = true

	shop_screen.animation.play("pop")
	await shop_screen.animation.animation_finished

	EventBus.stop_player_movement.emit()
	Util.mouse_visible()
func close_shop_screen() -> void:
	shop_open = false
	EventBus.player_can_move.emit()

func open_microscope_screen() -> void:
	if microscope_open: return

	microscope_open = true
	microscope_screen.show()

	microscope_screen.animation.play("pop")
	await microscope_screen.animation.animation_finished

	EventBus.stop_player_movement.emit()
	Util.mouse_visible()
func close_microscope_screen() -> void:
	microscope_open = false
	EventBus.player_can_move.emit()

func open_antidote_screen() -> void:
	if antidote_open: return

	antidote_screen.opened()

	antidote_open = true
	antidote_screen.show()

	antidote_screen.animation.play("pop")
	await antidote_screen.animation.animation_finished

	EventBus.stop_player_movement.emit()
	Util.mouse_visible()
func close_antidote_screen() -> void:
	antidote_open = false
	EventBus.player_can_move.emit()

func open_incubator_screen(inc: Incubator) -> void:
	if incubator_open or not inc: return
	incubator = inc
	temperature = incubator.temperature

	incubator_open = true
	incubator_screen.show()

	EventBus.stop_player_movement.emit()

func close_incubator_screen() -> void:
	incubator_open = false
	
	incubator.temperature = temperature
	temperature = 1.0
	
	incubator = null
	incubator_screen.hide()
	
	EventBus.stop_player_movement.emit()

func set_tooltip_text(text: String) -> void:
	tooltip.text = text
func show_tooltip(text: String) -> void:
	if showing_warning: return
	
	tooltip.text = text
	set_hand_sprite()
	
	if not patient_open:
		interact_icon.show()
func show_warning(text: String) -> void:
	if showing_warning:
		warning_timer.stop()
		warning_timer.queue_free()

		warning_timer = null

	showing_warning = true
	tooltip.text = text

	warning_timer = Timer.new()
	warning_timer.one_shot = true
	add_child(warning_timer)

	warning_timer.timeout.connect(
		func() -> void:
			showing_warning = false
			tooltip.text = ""

			warning_timer.queue_free()
			warning_timer = null
	)
	warning_timer.start(warning_timer_speed)
func hide_tooltip() -> void:
	if showing_warning: return
	tooltip.text = ""

	var player: Player = Util.get_player()
	if not player: return

	set_hand_sprite()
	interact_icon.hide()

func set_hand_sprite() -> void:
	var player: Player = Util.get_player()
	if not player: return

	if player.held_item_id == ITEMS.IDS.clipboard and tooltip.text != "":
		hand.texture = load(Registry.UID.hand_point)
		held_item.hide()
	else:
		hand.texture = load(Registry.UID.hand_hold)
		held_item.show()
func add_subtitle(text: String) -> void:
	var subtitle: Label = load(Registry.UID.subtitle_instance).instantiate()
	subtitle_container.add_child(subtitle)

	if text:
		subtitle.text = text

func add_guide_text_letter(letter: String) -> void:
	if guide_text_index >= guide_text.length() or not guide_text_active: return
	
	guide_text_label.text = letter
	guide_text_index += 1
	
	await get_tree().create_timer(guide_text_speed).timeout
	add_guide_text_letter(guide_text[guide_text_index])

func add_guide_text(text: String) -> void:
	guide_text = text
	
	guide_text_label.show()
	guide_container.show()
	
	guide_text_active = true
	add_guide_text(guide_text[guide_text_index])

func hide_guide() -> void:
	guide_text_label.hide()
	guide_container.hide()
	
	guide_text_label.text = ""
	guide_text_active = false
