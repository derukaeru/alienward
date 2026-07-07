class_name BioluminescenceEffect extends BaseEffect

func activate(baby: Baby) -> void:
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	
	shader_material.shader = load(Registry.UID["bioluminescence_shader"])
	baby.sprite.material = shader_material
	
	var timer: SceneTreeTimer = get_tree().create_timer(baby.effect.duration)
	timer.timeout.connect(deactivate.bind(baby))

func deactivate(baby: Baby) -> void:
	baby.sprite.material = null
