class_name TechNodeCard
extends MarginContainer

signal selected(id: String)

@export var tech_id: String = ""

@onready var locked_texture: NinePatchRect = $LockedTexture
@onready var available_texture: NinePatchRect = $AvailableTexture
@onready var unlocked_texture: NinePatchRect = $UnlockedTexture
@onready var name_label: Label = $Container/NameLabel
@onready var cost_label: Label = $Container/CostLabel

const CARD_SHADER = preload("res://Scenes/Utils/UI/CustomButton.gdshader")

@export_group("Hover")
@export var pixel_size_start: float = 16.0
@export var pixel_duration: float = 0.85

var _tween: Tween
var _active_texture: NinePatchRect


func _ready() -> void:
	var node := TechTreeState.get_node_config(tech_id)
	if node.is_empty():
		push_error("TechNodeCard: no node config found for id '%s'" % tech_id)
		return

	name_label.text = node["label"]

	if node["pre_unlocked"]:
		cost_label.text = "PRE"
	elif node["coming_soon"]:
		cost_label.text = "SOON"
	else:
		cost_label.text = "%d pt" % node["cost"]

	# Asignar shader a las tres texturas
	for texture in [locked_texture, available_texture, unlocked_texture]:
		var mat := ShaderMaterial.new()
		mat.shader = CARD_SHADER
		texture.material = mat

	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	add_to_group(Constants.TECH_NODE_GROUP)

	refresh()


func refresh() -> void:
	var node := TechTreeState.get_node_config(tech_id)
	if node.is_empty():
		return

	locked_texture.hide()
	available_texture.hide()
	unlocked_texture.hide()

	if node["coming_soon"]:
		_active_texture = locked_texture
		modulate = Color(0.4, 0.4, 0.4, 0.6)
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	elif TechTreeState.is_unlocked(tech_id):
		_active_texture = unlocked_texture
		modulate = Color.WHITE
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	elif TechTreeState.can_unlock(tech_id):
		_active_texture = available_texture
		modulate = Color.WHITE
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		_active_texture = locked_texture
		modulate = Color.WHITE
		mouse_default_cursor_shape = Control.CURSOR_ARROW

	_active_texture.show()


func _on_hover() -> void:
	var node := TechTreeState.get_node_config(tech_id)
	if node.is_empty() or node["coming_soon"]:
		return
	UIAudioManager.play_hover()
	(_active_texture.material as ShaderMaterial).set_shader_parameter("hovering", true)
	_animate_pixel(pixel_size_start, 1.0)


func _on_unhover() -> void:
	if _active_texture == null:
		return
	(_active_texture.material as ShaderMaterial).set_shader_parameter("hovering", false)


func _animate_pixel(px_from: float, px_to: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	var mat := _active_texture.material as ShaderMaterial
	mat.set_shader_parameter("pixel_size", px_from)
	_tween.tween_method(
		func(v: float): mat.set_shader_parameter("pixel_size", v),
		px_from, px_to, pixel_duration
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func _gui_input(event: InputEvent) -> void:
	var node := TechTreeState.get_node_config(tech_id)
	if node.is_empty() or node["coming_soon"]:
		return
	if event.is_action_pressed("click"):
		UIAudioManager.play_click()
		selected.emit(tech_id)
