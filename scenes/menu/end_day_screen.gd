extends Control
@onready var end_day_label: TextureRect = $end_day_label

@onready var served_patients_label: Label = $served_patients
@onready var dirtiness_label: Label = $dirtiness
@onready var patient_satisfaction_label: Label = $patient_satisfaction
@onready var money_earned_label: Label = $money_earned

var served_patients: int = 0
var dirtiness: float = 0.0
var patient_satisfaction: float = 0.0
var money_earned: int = 0

func _ready() -> void:
	EventBus.add_end_screen_details.connect(add_details)
	
	Util.mouse_visible()
	GameManager.reset_day()
	GameManager.ui.hide()
	
	show_details()

func add_details(sp: int, d: float, ps: float, m: int) -> void:
	served_patients = sp
	dirtiness = d
	patient_satisfaction = ps
	money_earned = m

func _continue() -> void:
	pass 

func menu() -> void:
	pass

func show_details() -> void:
	await get_tree().create_timer(1.5).timeout
	served_patients_label.text = "Served Patients: "
	served_patients_label.show()
	await get_tree().create_timer(0.6).timeout
	served_patients_label.text = "Served Patients: " + str(served_patients)
	
	await get_tree().create_timer(0.8).timeout
	dirtiness_label.text = "Dirtiness: "
	dirtiness_label.show()
	await get_tree().create_timer(0.6).timeout
	dirtiness_label.text = "Dirtiness: " + str(dirtiness)
	
	await get_tree().create_timer(0.8).timeout
	patient_satisfaction_label.text = "Patient Satisfaction: "
	patient_satisfaction_label.show()
	await get_tree().create_timer(0.6).timeout
	patient_satisfaction_label.text = "Patient Satisfaction: " + str(patient_satisfaction)
	
	await get_tree().create_timer(0.8).timeout
	money_earned_label.text = "Money Earned: "
	money_earned_label.show()
	await get_tree().create_timer(0.6).timeout
	money_earned_label.text = "Money Earned: " + str(money_earned)
	
	await get_tree().create_timer(0.6).timeout
	$continue.show()
	await get_tree().create_timer(0.3).timeout
	$menu.show()
	
