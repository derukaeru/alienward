class_name HypothermiaEffect extends BaseEffect

func activate(baby: Baby) -> void:
	pass

func deactivate(baby: Baby) -> void:
	baby.state = Baby.STATES.SLEEPING
