class_name TechNodeCard
extends MarginContainer

signal selected(id: String)

@export var tech_id: String = ""

@onready var locked_texture: NinePatchRect = $LockedTexture
@onready var available_texture: NinePatchRect = $AvailableTexture
@onready var unlocked_texture: NinePatchRect = $UnlockedTexture
@onready var name_label: Label = $Container/NameLabel
@onready var cost_label: Label = $Container/CostLabel


func _ready() -> void:
	add_to_group(Constants.TECH_NODE_GROUP)
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

	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)

	refresh()


func refresh() -> void:
	var node := TechTreeState.get_node_config(tech_id)
	if node.is_empty():
		return

	# Reset
	locked_texture.hide()
	available_texture.hide()
	unlocked_texture.hide()

	if node["coming_soon"]:
		locked_texture.show()
		modulate = Color(0.4, 0.4, 0.4, 0.6)
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
		return

	modulate = Color.WHITE

	if TechTreeState.is_unlocked(tech_id):
		unlocked_texture.show()
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	elif TechTreeState.can_unlock(tech_id):
		available_texture.show()
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		locked_texture.show()
		mouse_default_cursor_shape = Control.CURSOR_ARROW


func _on_hover() -> void:
	var node := TechTreeState.get_node_config(tech_id)
	if node.is_empty() or node["coming_soon"]:
		return
	UIAudioManager.play_hover()


func _gui_input(event: InputEvent) -> void:
	var node := TechTreeState.get_node_config(tech_id)
	if node.is_empty() or node["coming_soon"]:
		return
	if event.is_action_pressed("click"):
		UIAudioManager.play_click()
		selected.emit(tech_id)


func _on_unhover() -> void:
	pass
