extends Node

var EFFECTS: Dictionary = {}

func _ready() -> void:
	EFFECTS[0] = BioluminescenceEffect.new()
	EFFECTS[1] = CrystalGrowthEffect.new()
	EFFECTS[2] = HallucinogenicFumesEffect.new()
	EFFECTS[3] = HyperhydrosisEffect.new()
	EFFECTS[4] = HypothermiaEffect.new()
	EFFECTS[5] = SoundMimicryEffect.new()
	EFFECTS[6] = SpontaneousCombustionEffect.new()
	EFFECTS[7] = StaticDischargeEffect.new()
	EFFECTS[8] = TeleportationEffect.new()
	EFFECTS[9] = ZeroGravityEffect.new()

func apply_effect(baby: Baby, effect_data: Dictionary) -> void:
	var idx: int = effect_data["effect_index"]
	if EFFECTS.has(idx):
		EFFECTS[idx].activate(baby, effect_data)
