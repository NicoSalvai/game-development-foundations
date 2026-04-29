extends Node

enum Stat {
	NONE,
	PISTOL_DAMAGE,
	PISTOL_FIRE_RATE,
	SNIPER_DAMAGE,
	SHOTGUN_PELLETS,
	MAX_HP,
	DASH_COOLDOWN,
}

const TECH_NODES: Array[Dictionary] = [
	{ "id": "pistol",       "label": "Pistol",          "cost": 0, "pre_unlocked": true,  "coming_soon": false, "requires": [],              "stat": Stat.NONE,            "modifier_delta": 0.0  },
	{ "id": "dash",         "label": "Dash",             "cost": 0, "pre_unlocked": true,  "coming_soon": false, "requires": [],              "stat": Stat.NONE,            "modifier_delta": 0.0  },
	{ "id": "sniper",       "label": "Sniper",           "cost": 1, "pre_unlocked": false, "coming_soon": false, "requires": ["pistol"],      "stat": Stat.NONE,            "modifier_delta": 0.0  },
	{ "id": "shotgun",      "label": "Shotgun",          "cost": 1, "pre_unlocked": false, "coming_soon": false, "requires": ["pistol"],      "stat": Stat.NONE,            "modifier_delta": 0.0  },
	{ "id": "pistol_dmg",   "label": "Pistol +DMG",      "cost": 1, "pre_unlocked": false, "coming_soon": false, "requires": ["pistol"],      "stat": Stat.PISTOL_DAMAGE,   "modifier_delta": 0.5 },
	{ "id": "pistol_rate",  "label": "Pistol +Firerate", "cost": 1, "pre_unlocked": false, "coming_soon": false, "requires": ["pistol"],      "stat": Stat.PISTOL_FIRE_RATE,"modifier_delta": -0.20},
	{ "id": "sniper_dmg",   "label": "Sniper +DMG",      "cost": 1, "pre_unlocked": false, "coming_soon": false, "requires": ["sniper"],      "stat": Stat.SNIPER_DAMAGE,   "modifier_delta": 0.25 },
	{ "id": "shotgun_pellets","label": "Shotgun +Spread","cost": 1, "pre_unlocked": false, "coming_soon": false, "requires": ["shotgun"],     "stat": Stat.SHOTGUN_PELLETS, "modifier_delta": 0.33 },
	{ "id": "max_hp",       "label": "+Max HP",          "cost": 1, "pre_unlocked": false, "coming_soon": false, "requires": [],              "stat": Stat.MAX_HP,          "modifier_delta": 0.20 },
	{ "id": "dash_cooldown","label": "Dash +Cooldown",   "cost": 1, "pre_unlocked": false, "coming_soon": false, "requires": ["dash"],        "stat": Stat.DASH_COOLDOWN,   "modifier_delta": -0.25},
	{ "id": "shield",       "label": "Shield",           "cost": 2, "pre_unlocked": false, "coming_soon": true,  "requires": ["max_hp"],      "stat": Stat.NONE,            "modifier_delta": 0.0  },
]

var skill_points: int = 0
var _unlocked_nodes: Array[String] = []
var _modifiers: Dictionary = {}


func _ready() -> void:
	_init_pre_unlocked()
	_compute_modifiers()


func _init_pre_unlocked() -> void:
	for node in TECH_NODES:
		if node["pre_unlocked"] and not node["id"] in _unlocked_nodes:
			_unlocked_nodes.append(node["id"])

func get_save_data() -> Dictionary:
	return {
		"skill_points": skill_points,
		"unlocked_nodes": _unlocked_nodes.duplicate(),
	}


func load_save_data(data: Dictionary) -> void:
	if data.has("skill_points"):
		skill_points = data["skill_points"]
	if data.has("unlocked_nodes"):
		_unlocked_nodes = []
		for unlocked in data["unlocked_nodes"]:
			_unlocked_nodes.append(unlocked) 
	_compute_modifiers()


func add_skill_point() -> void:
	skill_points += 1


func reset() -> void:
	skill_points = 0
	_unlocked_nodes.clear()
	_init_pre_unlocked()
	_compute_modifiers()


func is_unlocked(id: String) -> bool:
	return id in _unlocked_nodes


func get_node_config(id: String) -> Dictionary:
	for node in TECH_NODES:
		if node["id"] == id:
			return node
	return {}


func can_unlock(id: String) -> bool:
	var node := get_node_config(id)
	if node.is_empty():
		return false
	if node["coming_soon"]:
		return false
	if is_unlocked(id):
		return false
	if skill_points < node["cost"]:
		return false
	for req in node["requires"]:
		if not is_unlocked(req):
			return false
	return true


func can_relock(id: String) -> bool:
	var node := get_node_config(id)
	if node.is_empty():
		return false
	if node["pre_unlocked"]:
		return false
	if not is_unlocked(id):
		return false
	# No se puede relockear si otro nodo desbloqueado lo requiere
	for other in TECH_NODES:
		if id in other["requires"] and is_unlocked(other["id"]):
			return false
	return true


func unlock_node(id: String) -> void:
	if not can_unlock(id):
		return
	var node := get_node_config(id)
	skill_points -= node["cost"]
	_unlocked_nodes.append(id)
	_compute_modifiers()
	SaveManager.save()


func relock_node(id: String) -> void:
	if not can_relock(id):
		return
	var node := get_node_config(id)
	_unlocked_nodes.erase(id)
	skill_points += node["cost"]
	_compute_modifiers()
	SaveManager.save()


func get_modifier(stat: Stat) -> float:
	if stat == Stat.NONE:
		return 1.0
	return _modifiers.get(stat, 1.0)


func _compute_modifiers() -> void:
	_modifiers.clear()
	for id in _unlocked_nodes:
		var node := get_node_config(id)
		if node.is_empty():
			continue
		var stat: Stat = node["stat"]
		if stat == Stat.NONE:
			continue
		var current: float = _modifiers.get(stat, 1.0)
		_modifiers[stat] = current + node["modifier_delta"]
