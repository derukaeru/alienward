extends Node3D

@onready var interactable: InteractableComponent = $InteractableComponent
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	interactable.tooltip_text = Lang.TOOLTIPS.shop

func _on_interactable_component_interacted() -> void:
	var player: Player = Util.get_player()
	if not player: return
	
	if player.ui_layer.shop_open: return
	
	animation.play("pop")
	player.ui_layer.open_shop_screen()

func buy_item(item_id: String) -> void:
	if not ITEMS.SHOP_ITEMS.has(item_id): 
		print("This item is not in the SHOP ITEMS list. Item: \"%d\"" % item_id)
		return
	
	var item: Item = load(Registry.UID[ITEMS.SHOP_ITEMS[item_id]]).instantiate()
	var container: Node3D = Util.get_group_node("entities_container")
	var item_chute: Node3D = Util.get_group_node("item_chute")
	
	container.add_child(item)
	item.global_position = item_chute.global_position + Vector3(0.0, -1.5, 0.0)
