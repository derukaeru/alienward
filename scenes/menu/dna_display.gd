extends Control


# DNA HELIX

const HELIX_CENTER: Vector2 = Vector2(180.0, 40.0)
const HELIX_RADIUS: float = 60
const BACKBONE_COLOR: Color = Color(0.818, 0.818, 0.818, 1.0)
const BACKBONE_WIDTH: float = 5.0
var pairs: Array = []

var COLORS: Array = [
	Color(0.744, 0.461, 0.202, 1.0),
	Color(0.183, 0.45, 0.566, 1.0),
	Color(0.316, 0.506, 0.312, 1.0),
	Color(0.686, 0.373, 0.619, 1.0)
]

func _ready() -> void:
	for i in range(16):
		var color_index: int = (i % 2) * 2 
		
		pairs.append({
			dot1 = Vector2(HELIX_CENTER.x - HELIX_RADIUS + cos(i) * 10, HELIX_CENTER.y + i * 20),
			dot2 = Vector2(HELIX_CENTER.x + HELIX_RADIUS - cos(i) * 10, HELIX_CENTER.y + i * 20),
			color1 = COLORS[color_index],
			color2 = COLORS[color_index + 1]
		})

func _process(_delta) -> void:
	var time_elapsed: float = Time.get_ticks_msec() / 1000.0

	for i in pairs.size():
		var angle: float = time_elapsed + i * 0.4

		pairs[i].dot1.x = HELIX_CENTER.x - cos(angle) * HELIX_RADIUS
		pairs[i].dot2.x = HELIX_CENTER.x + cos(angle) * HELIX_RADIUS

	queue_redraw()

func _draw():
	for i in pairs.size():
		var pair = pairs[i]
		
		
		draw_line(pair.dot1, Vector2(HELIX_CENTER.x, pair.dot1.y), pair.color1, BACKBONE_WIDTH)
		draw_line(pair.dot2, Vector2(HELIX_CENTER.x, pair.dot2.y), pair.color2, BACKBONE_WIDTH)
		
		draw_circle(pair.dot1, 5, BACKBONE_COLOR, true)
		draw_circle(pair.dot2, 5, BACKBONE_COLOR, true)
		
		if i + 1 > pairs.size() - 1: return
		
		var pair1 = pairs[i]
		var pair2 = pairs[i + 1]
		
		draw_line(pair1.dot1, pair2.dot1, BACKBONE_COLOR, BACKBONE_WIDTH)
		draw_line(pair1.dot2, pair2.dot2, BACKBONE_COLOR, BACKBONE_WIDTH)
