extends Node

func play_single_particle(parent, particle_name: String) -> void:
	if not Registry.particles.has(particle_name): return
	
	var particle: GPUParticles3D = load(Registry.particles[particle_name]).instantiate()
	parent.add_child(particle)

func play_compound_particle(parent, particle_name: String) -> void:
	if not Registry.particles.has(particle_name): return
	
	var particle: GPUParticles3D = load(Registry.particles[particle_name]).instantiate()
	parent.add_child(particle)
