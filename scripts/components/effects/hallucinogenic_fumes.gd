class_name HallucinogenicFumesEffect extends BaseEffect

func activate(baby: Baby) -> void:
	var fumes: Fumes = load(Registry.UID["fumes"]).instantiate()
	fumes.global_position = baby.global_position
	fumes.duration = baby.effect.duration
	fumes.baby = baby

	Util.add_entity_to_container(fumes)

func deactivate(baby: Baby) -> void:
	baby.state = Baby.STATES.SLEEPING
	baby.set_effect_activation()
