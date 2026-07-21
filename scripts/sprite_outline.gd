@tool
class_name Sprite3dOutlineShader
extends Sprite3D

var _last_material: ShaderMaterial
func _ready() -> void:
	texture_changed.connect(_update_shader_texture)
	set_process(true)
	_update_shader_material()

func _process(_delta: float) -> void:
	if material_override != _last_material:
		_update_shader_material()

func _update_shader_material() -> void:
	_last_material = material_override as ShaderMaterial
	_update_shader_texture()

func _update_shader_texture() -> void:
	var mat := material_override as ShaderMaterial
	if mat and texture:
		mat.set_shader_parameter("sprite_texture", texture)

func set_line_color(color: Color) -> void:
	var mat := material_override as ShaderMaterial
	if mat:
		mat.set_shader_parameter("line_color", color)
	else:
		push_warning("Missing ShaderMaterial in material_override – can’t set line_color.")

func enable_outline(enable: bool) -> void:
	var mat := material_override as ShaderMaterial
	if mat:
		mat.set_shader_parameter("enable_outline", enable)
	else:
		push_warning("Missing ShaderMaterial in material_override – can’t set enable_outline.")
