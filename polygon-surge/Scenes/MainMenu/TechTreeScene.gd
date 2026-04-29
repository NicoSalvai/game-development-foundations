class_name TechTreeScene
extends Control

@onready var skill_points_label: Label = $MarginContainer/Layout/HeaderLayout/SkillPointsLabel
@onready var info_panel: MarginContainer = $MarginContainer/Layout/BodyLayout/InfoPanel
@onready var node_name_label: Label = $MarginContainer/Layout/BodyLayout/InfoPanel/PanelContainer/VBoxContainer/NodeNameLabel
@onready var node_desc_label: Label = $MarginContainer/Layout/BodyLayout/InfoPanel/PanelContainer/VBoxContainer/NodeDescLabel
@onready var action_button = $MarginContainer/Layout/BodyLayout/InfoPanel/PanelContainer/VBoxContainer/ActionButton

var _cards: Array[TechNodeCard] = []
var _selected_id: String = ""


func _ready() -> void:
	GameManager.set_cursor()
	info_panel.hide()
	action_button.clicked.connect(_on_action_pressed)
	_collect_cards()
	_refresh()


func _collect_cards() -> void:
	for node in get_tree().get_nodes_in_group(Constants.TECH_NODE_GROUP):
		var card := node as TechNodeCard
		card.selected.connect(_on_node_selected)
		_cards.append(card)


func _refresh() -> void:
	skill_points_label.text = "Skill Points: %d" % TechTreeState.skill_points
	for card in _cards:
		card.refresh()
	if _selected_id != "":
		_refresh_info_panel()


func _on_node_selected(id: String) -> void:
	_selected_id = id
	info_panel.show()
	_refresh_info_panel()


func _refresh_info_panel() -> void:
	var node := TechTreeState.get_node_config(_selected_id)
	if node.is_empty():
		return

	node_name_label.text = node["label"]
	node_desc_label.text = _build_desc(node)

	if node["coming_soon"]:
		action_button.hide()
		return

	action_button.show()

	if TechTreeState.is_unlocked(_selected_id):
		action_button.set_label("Refund")
		action_button.disable(not TechTreeState.can_relock(_selected_id))
	else:
		action_button.set_label("Unlock")
		action_button.disable(not TechTreeState.can_unlock(_selected_id))


func _build_desc(node: Dictionary) -> String:
	var lines: Array[String] = []

	if node["coming_soon"]:
		lines.append("Coming soon.")
		return "\n".join(lines)

	if node["pre_unlocked"]:
		lines.append("Desbloqueado por defecto.")
	else:
		lines.append("Costo: %d pt" % node["cost"])

	if not node["requires"].is_empty():
		lines.append("Requiere: %s" % ", ".join(node["requires"]))

	if node["stat"] != TechTreeState.Stat.NONE:
		lines.append("Modifica: %s" % _stat_label(node["stat"]))
		var sign := "+" if node["modifier_delta"] > 0 else ""
		lines.append("Efecto: %s%d%%" % [sign, roundi(node["modifier_delta"] * 100)])

	return "\n".join(lines)


func _stat_label(stat: TechTreeState.Stat) -> String:
	match stat:
		TechTreeState.Stat.PISTOL_DAMAGE:    return "Daño pistola"
		TechTreeState.Stat.PISTOL_FIRE_RATE: return "Cadencia pistola"
		TechTreeState.Stat.SNIPER_DAMAGE:    return "Daño sniper"
		TechTreeState.Stat.SHOTGUN_PELLETS:  return "Perdigones escopeta"
		TechTreeState.Stat.MAX_HP:           return "HP máximo"
		TechTreeState.Stat.DASH_COOLDOWN:    return "Cooldown dash"
		_: return ""


func _on_action_pressed() -> void:
	if TechTreeState.is_unlocked(_selected_id):
		TechTreeState.relock_node(_selected_id)
	else:
		TechTreeState.unlock_node(_selected_id)
	_refresh()


func _on_map_button_clicked() -> void:
	GameManager.load_map_scene()
