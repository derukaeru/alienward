class_name Dirt extends InteractableComponent

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite3D = $Sprite3D

var cleaning: bool = false
var cleaning_timer: Timer
var cleaning_speed: float = 5.0

func _ready() -> void:
	animation.play("show")
	sprite.rotation.y = randf_range(0, 360)

func clean(player: Player) -> void:
	player.ui.cleaning_progress.max_value = cleaning_speed
	player.ui.cleaning_progress.show()
	
	cleaning = true
	cleaning_timer = Timer.new()
	add_child(cleaning_timer)
	
	cleaning_timer.timeout.connect(cleaned)
	cleaning_timer.start(cleaning_speed)

func cleaned() -> void:
	EventBus.done_cleaning.emit()
	
	animation.play_backwards("show")
	await animation.animation_finished
	
	queue_free()

func _process(_delta) -> void:
	if cleaning: 
		var player: Player = Util.get_player()
		if not player: return
		
		player.ui.cleaning_progress.value = cleaning_speed - cleaning_timer.time_left
		
		if player.raycast.get_collider() != self:
			player.ui.cleaning_progress.hide()
			cleaning = false
			
			cleaning_timer.stop()
			cleaning_timer.queue_free()
			cleaning_timer = null
			
