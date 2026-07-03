class_name HyperhydrosisEffect extends BaseEffect

var spawning_water: bool = false
var spawn_timer: Timer
var stop_spawn_timer: Timer

func activate(baby: Baby) -> void:
	if spawning_water: return
	print("spawning water")
	spawning_water = true
	
	spawn_timer = Timer.new()
	spawn_timer.timeout.connect(spawn_water.bind(baby))
	
	Util.add_entity_to_container(spawn_timer)
	spawn_timer.start(0.3)
	
	stop_spawn_timer = Timer.new()
	stop_spawn_timer.timeout.connect(deactivate)
	
	Util.add_entity_to_container(stop_spawn_timer)
	stop_spawn_timer.start(baby.effect.duration)

func deactivate() -> void:
	spawn_timer.stop()
	
	spawn_timer.queue_free()
	stop_spawn_timer.queue_free()
	
	spawning_water = false
	print("stopped spawning water")

func spawn_water(baby: Baby) -> void:
	var water_spill: WaterSpill = load(Registry.UID["water_spill"]).instantiate()
	Util.add_entity_to_container(water_spill)
	
	water_spill.global_position = baby.global_position + Vector3(randi_range(-5, 5), 0.0, randi_range(-5, 5))
	water_spill.global_position.y = 0.1
	
	# water spill position randomly around the baby
	# position is offset (0.0, 0.1, 0.0) above the ground
