class_name BioluminescenceEffect extends BaseEffect

func activate(baby: Baby) -> void:
	if not baby: return
	
	#var shader_material: ShaderMaterial = ShaderMaterial.new()
	#shader_material.shader = load(Registry.UID["bioluminescence_shader"])
	#baby.sprite.material = shader_material
	
	var particle: GPUParticles3D = load(Registry.particles.bioluminesce).instantiate()
	baby.add_child(particle)
	baby.particles = particle
	
	var timer: Timer = Timer.new()
	timer.wait_time = baby.effect.duration
	timer.one_shot = true
	
	baby.add_child(timer)
	
	baby.sprite.enable_outline(true)
	timer.timeout.connect(deactivate.bind(baby))
	
	timer.start()

func deactivate(baby: Baby) -> void:
	baby.sprite.enable_outline(false)
	baby.state = Baby.STATES.SLEEPING
	
	baby.set_effect_activation()
	
	if baby.particles:
		baby.particles.emitting = false
