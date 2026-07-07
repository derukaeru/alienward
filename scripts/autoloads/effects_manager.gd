extends Node

var EFFECTS: Dictionary = {}

func _ready() -> void:
	EFFECTS[0] = HyperhydrosisEffect.new()
	EFFECTS[1] = BioluminescenceEffect.new()

func apply_effect(baby: Baby) -> void:
	var idx: int = baby.effect["effect_index"]
	if EFFECTS.has(idx):
		EFFECTS[idx].activate(baby)
