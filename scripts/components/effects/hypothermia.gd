class_name HypothermiaEffect extends BaseEffect

func activate(baby: Baby) -> void:
	var freeze_puddle: FreezePuddle = load(Registry.UID.freeze_puddle_instance).instantiate()
	Util.add_entity_to_container(freeze_puddle)
	
	freeze_puddle.global_position = baby.global_position
	freeze_puddle.duration = baby.effect.duration
	freeze_puddle.baby = baby

func deactivate(baby: Baby) -> void:
	baby.state = Baby.STATES.SLEEPING
	baby.set_effect_activation()
