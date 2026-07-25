extends InteractableComponent

@onready var animation: AnimationPlayer = $ModelContainer/AnimationPlayer
@onready var paper_mesh: MeshInstance3D = $ModelContainer/paper

func _ready() -> void:
	tooltip_text = Lang.TOOLTIPS.printer
	EventBus.generate_image.connect(print_ultrasound)

var printed: bool = false
var printing: bool = false

var patient_id: int = GameManager.UNASSIGNED

func print_ultrasound(id: int = GameManager.UNASSIGNED) -> void:
	if printed or printing or id == GameManager.UNASSIGNED: return
	patient_id = id

	animation.play("print")
	printing = true

	await animation.animation_finished

	printing = false
	printed = true

	Util.add_subtitle(Lang.subtitles.generated_print)

func interact() -> void:
	var player: Player = Util.get_player()
	if not printed or not player: return

	animation.play("RESET")
	printed = false

	var paper: Item = load(Registry.UID.ultrasound_print_instance).instantiate()
	Util.add_entity_to_container(paper)

	paper.patient_id = patient_id
	player.pick_up(paper)

	patient_id = GameManager.UNASSIGNED
