extends Node

enum LevelStatus { LOCKED, AVAILABLE, COMPLETED }

@export var initial_states: Dictionary[int, LevelStatus] = {
	1: LevelStatus.AVAILABLE,
}

var _states: Dictionary[int, LevelStatus] = {
	1: LevelStatus.COMPLETED,
	2: LevelStatus.AVAILABLE,
	3: LevelStatus.AVAILABLE,
	4: LevelStatus.AVAILABLE,
}


func _ready() -> void:
	SignalHub.level_cleared.connect(_on_level_cleared)


func get_status(level_id: int) -> LevelStatus:
	return _states.get(level_id, LevelStatus.LOCKED)


func set_completed(level_id: int) -> void:
	_states[level_id] = LevelStatus.COMPLETED
	_states[level_id + 1] = LevelStatus.AVAILABLE


func reset() -> void:
	_states = initial_states.duplicate()

func has_progress() -> bool:
	return LevelStatus.COMPLETED in _states.values()

func _on_level_cleared() -> void:
	set_completed(GameManager._selected_level)
