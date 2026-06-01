extends Node3D

func _on_interactable_component_interacted() -> void:
	if GameManager.shop_open: return
	
	GameManager.open_shop_screen()
	Util.mouse_visible()
