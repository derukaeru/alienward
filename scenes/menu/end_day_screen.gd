extends Control
@onready var end_day_label: TextureRect = $end_day_label

@onready var served_patients_label: Label = $served_patients
@onready var dirtiness_label: Label = $dirtiness
@onready var patient_satisfaction_label: Label = $patient_satisfaction
@onready var money_earned_label: Label = $money_earned

func _ready() -> void:
	EventBus.add_end_screen_details.connect(add_details)
	
	Util.mouse_visible()
	GameManager.reset_day()
	GameManager.ui.hide()

func add_details(served_patients: int, dirtiness: float, patient_satisfaction: float, money_earned: int) -> void:
	served_patients_label.text = "Served Patients: " + str(served_patients)
	dirtiness_label.text = "Dirtiness: " + str(dirtiness)
	patient_satisfaction_label.text = "Patient Satisfaction" + str(patient_satisfaction)
	money_earned_label.text = "Money Earned: " + str(money_earned)

func _continue() -> void:
	pass 

func menu() -> void:
	pass
