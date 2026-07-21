class_name BioluminescenceEffect extends BaseEffect

func activate(baby: Baby) -> void:
	if not baby: return
	
	#var shader_material: ShaderMaterial = ShaderMaterial.new()
	#shader_material.shader = load(Registry.UID["bioluminescence_shader"])
	#baby.sprite.material = shader_material
	
	var timer: Timer = Timer.new()
	timer.wait_time = baby.effect.duration
	timer.one_shot = true
	
	Util.add_entity_to_container(timer)
	
	baby.sprite.enable_outline(true)
	timer.timeout.connect(deactivate.bind(baby))
	
	timer.start()

func deactivate(baby: Baby) -> void:
	baby.sprite.enable_outline(false)
	baby.state = Baby.STATES.SLEEPING
	
	baby.set_effect_activation()
