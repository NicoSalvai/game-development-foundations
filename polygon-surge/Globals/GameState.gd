extends Node

# ------------------------------------------------------------------ Enums ---

enum LevelStatus { LOCKED, AVAILABLE, COMPLETED }

# ------------------------------------------------------------- Level data ---

@export var initial_states: Dictionary[int, LevelStatus] = {
	1: LevelStatus.AVAILABLE
}

var _states: Dictionary[int, LevelStatus] = {
}

# ------------------------------------------------------------------ Ready ---

func _ready() -> void:
	SignalHub.level_cleared.connect(_on_level_cleared)
	SaveManager.load_save()

# ----------------------------------------------------------- Level API ---

func get_status(level_id: int) -> LevelStatus:
	return _states.get(level_id, LevelStatus.LOCKED)


func set_completed(level_id: int) -> void:
	if _states[level_id] == LevelStatus.AVAILABLE:
		TechTreeState.add_skill_point()
	_states[level_id] = LevelStatus.COMPLETED
	_states[level_id + 1] = LevelStatus.AVAILABLE
	SaveManager.save()
	

func reset() -> void:
	_states = initial_states.duplicate()
	TechTreeState.reset()
	SaveManager.delete_save()


func has_progress() -> bool:
	return LevelStatus.COMPLETED in _states.values()


func get_save_data() -> Dictionary:
	var serialized: Dictionary = {}
	for key in _states:
		serialized[str(key)] = _states[key]
	return { "level_states": serialized }


func load_save_data(data: Dictionary) -> void:
	if not data.has("level_states"):
		return
	_states.clear()
	for key in data["level_states"]:
		_states[int(key)] = data["level_states"][key] as LevelStatus
# ---------------------------------------------------------------- Signals ---

func _on_level_cleared() -> void:
	set_completed(GameManager._selected_level)
