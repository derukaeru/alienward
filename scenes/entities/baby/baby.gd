class_name Baby extends InteractableComponent

var needs: Array = []

func pick_up() -> void:
	Util.get_player().held_baby = self
	Util.get_player().clipboard.hide()
	Util.get_player().baby.show()
	
	hide()
	
	reparent(Util.get_group_node("camera"))
	global_position = Vector3.ZERO
	position = Vector3(-0.5, -0.35, -1)
	
	set_collision_layer_value(1, false)
