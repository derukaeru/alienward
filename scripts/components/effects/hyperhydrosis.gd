class_name HyperhydrosisEffect extends BaseEffect

var spawn_water_components: Dictionary

var spawn_radius: float = 1.0

func activate(baby: Baby) -> void:
	if spawn_water_components.has(str(baby.id)): return
	var new_water_spawn: Array = []
	
	# spawn timer
	new_water_spawn.append(Timer.new())
	new_water_spawn[0].timeout.connect(spawn_water.bind(baby))
	Util.add_entity_to_container(new_water_spawn[0])
	new_water_spawn[0].start(0.3)
	
	# stop timer
	new_water_spawn.append(Timer.new())
	new_water_spawn[1].timeout.connect(deactivate.bind(baby))
	Util.add_entity_to_container(new_water_spawn[1])
	new_water_spawn[1].start(baby.effect.duration)
	
	spawn_water_components[str(baby.id)] = new_water_spawn

func deactivate(baby: Baby) -> void:
	if not spawn_water_components.has(str(baby.id)): return
	
	var id: String = str(baby.id)
	
	var spawn_timer: Timer = spawn_water_components[id][0]
	var stop_timer: Timer = spawn_water_components[id][1]
	
	spawn_timer.stop()

	spawn_timer.queue_free()
	stop_timer.queue_free()
	
	spawn_water_components.erase(id)
	baby.state = Baby.STATES.SLEEPING
	baby.set_effect_activation()

func spawn_water(baby: Baby) -> void:
	var water_spill: WaterSpill = load(Registry.UID["water_spill"]).instantiate()
	Util.add_entity_to_container(water_spill)

	var nav_map: RID = Util.get_nav_reg().get_navigation_map()
	var pos: Vector3 = get_random_navmesh_point_near(baby.global_position, spawn_radius, nav_map)

	water_spill.global_position = baby.global_position + Vector3(pos.x, 0.0, pos.y)
	water_spill.global_position.y = 0.1

func get_random_navmesh_point_near(center: Vector3, radius: float, nav_map: RID, max_tries: int = 5) -> Vector3:
	for i in max_tries:
		var angle = randf() * TAU
		var dist = sqrt(randf()) * radius
		var candidate = center + Vector3(cos(angle) * dist, 0, sin(angle) * dist)

		# snap to navmesh
		var closest = NavigationServer3D.map_get_closest_point(nav_map, candidate)

		# make sure it actually landed close (i.e. it's real navmesh, not clamped from far away)
		if candidate.distance_to(Vector3(closest.x, candidate.y, closest.z)) < 0.5:
			return closest

	return center
