shader_type canvas_item;

uniform sampler2D screen_tex: hint_screen_texture;
uniform float speed = 1.0;

void fragment() {
	vec2 uv = vec2(UV.x * sin(TIME * speed), UV.y * sin(TIME * speed));
	vec4 screen = texture(screen_tex, uv);
	COLOR = screen;
}
