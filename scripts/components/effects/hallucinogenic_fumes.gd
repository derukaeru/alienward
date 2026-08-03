class_name HallucinogenicFumesEffect extends BaseEffect

func activate(baby: Baby) -> void:
	var fume: Fumes = load(Registry.UID["fumes"]).instantiate()
	Util.add_entity_to_container(fume)
	
	fume.global_position = baby.global_position
	fume.duration = baby.effect.duration
	fume.baby = baby
	
	EventBus.baby_cured.connect(
		func(id: int) -> void:
			if id == fume.baby.id:
				fume.queue_free()
	)

func deactivate(baby: Baby) -> void:
	baby.state = Baby.STATES.SLEEPING
	baby.set_effect_activation()
