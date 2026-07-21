class_name HallucinogenicFumesEffect extends BaseEffect

func activate(baby: Baby) -> void:
	var fumes: Area3D = load(Registry.UID["fumes"]).instantiate()
	fumes.global_position = baby.global_position
	fumes.duration = baby.effect.duration
	fumes.baby = baby

	Util.add_entity_to_container(fumes)

func deactivate(baby: Baby) -> void:
	pass
