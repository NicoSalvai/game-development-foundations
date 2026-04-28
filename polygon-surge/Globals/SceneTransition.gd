extends Node

@export var pixel_size_max: float = 96.0
@export var fade_duration: float = 0.3
@export var pixel_duration: float = 0.4
const SCENE_TRANSITION = preload("uid://b0ihulm6stjg3")

var _canvas_layer: CanvasLayer
var _rect: ColorRect
var _shader_material: ShaderMaterial
var _tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.layer = 128
	add_child(_canvas_layer)

	_rect = ColorRect.new()
	_rect.color = Color(0, 0, 0, 0)
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_canvas_layer.add_child(_rect)

	_shader_material = ShaderMaterial.new()
	_shader_material.shader = SCENE_TRANSITION
	_rect.material = _shader_material
	_set_state(1.0, 0.0)

func transition_to(scene: PackedScene) -> void:
	await _transition_in()
	get_tree().paused = false
	get_tree().change_scene_to_packed(scene)
	await _transition_out()

func _transition_in() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)

	_tween.tween_method(
		func(v: float): _shader_material.set_shader_parameter("pixel_size", v),
		1.0, pixel_size_max, pixel_duration
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	_tween.tween_method(
		func(v: float): _shader_material.set_shader_parameter("alpha", v),
		0.0, 1.0, fade_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN) \
	.set_delay(pixel_duration * 0.4)

	await _tween.finished

func _transition_out() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)

	_tween.tween_method(
		func(v: float): _shader_material.set_shader_parameter("pixel_size", v),
		pixel_size_max, 1.0, pixel_duration
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT) \
	.set_delay(fade_duration * 0.4)

	_tween.tween_method(
		func(v: float): _shader_material.set_shader_parameter("alpha", v),
		1.0, 0.0, fade_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await _tween.finished

func _set_state(px: float, a: float) -> void:
	_shader_material.set_shader_parameter("pixel_size", px)
	_shader_material.set_shader_parameter("alpha", a)
