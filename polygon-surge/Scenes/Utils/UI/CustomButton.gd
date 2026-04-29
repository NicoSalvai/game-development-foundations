class_name CustomButtom
extends MarginContainer

@export var label: String = "Placeholder"
@export var disabled: bool = false

@export_group("Hover")
@export var pixel_size_start: float = 32.0
@export var pixel_duration: float = 0.85

@onready var button_label: Label = $Container/ButtonLabel
@onready var nine_patch: NinePatchRect = $Container/NinePatchRect
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

signal clicked 

var _tween: Tween
var _shader_nodes: Array[CanvasItem]

const CUSTOM_BUTTON_SHADER = preload("uid://2fligb5ut4dq")

func _ready() -> void:
	button_label.text = label
	
	_shader_nodes = [button_label, nine_patch if nine_patch else nine_patch_rect]
	for node in _shader_nodes:
		var mat := ShaderMaterial.new()
		mat.shader = load("res://Scenes/Utils/UI/CustomButton.gdshader")
		node.material = mat

	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)

	disable(disabled)


func disable(flag: bool = true) -> void:
	disabled = flag
	modulate = Color("c8c8c896") if disabled else Color.WHITE


func _on_hover() -> void:
	if disabled:
		return
	UIAudioManager.play_hover()
	for node in _shader_nodes:
		(node.material as ShaderMaterial).set_shader_parameter("hovering", true)
	_animate_pixel(pixel_size_start, 1.0)


func _on_unhover() -> void:
	if disabled:
		return
	for node in _shader_nodes:
		(node.material as ShaderMaterial).set_shader_parameter("hovering", false)


func _animate_pixel(px_from: float, px_to: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)

	for node in _shader_nodes:
		var mat := node.material as ShaderMaterial
		mat.set_shader_parameter("pixel_size", px_from)
		_tween.tween_method(
			func(v: float): mat.set_shader_parameter("pixel_size", v),
			px_from, px_to, pixel_duration
		).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func _on_gui_input(event: InputEvent) -> void:
	if not disabled and event.is_action_pressed("click"):
		UIAudioManager.play_click()
		clicked.emit()

func set_label(text: String) -> void:
	label = text
	button_label.text = text
