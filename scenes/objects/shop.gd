extends Node3D

@onready var interactable: InteractableComponent = $InteractableComponent
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	interactable.tooltip_text = Lang.TOOLTIPS.shop
	EventBus.shop_buy_item.connect(buy_item)

func _on_interactable_component_interacted() -> void:
	animation.play("pop")
	EventBus.open_shop.emit()

func buy_item(item_id: String) -> void:
	if not ITEMS.IDS.has(item_id): 
		print("This item is not in the SHOP ITEMS list. Item: \"%d\"" % item_id)
		return
	
	EventBus.generate_item.emit(item_id)
