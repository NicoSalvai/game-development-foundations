extends Node

const MAIN = preload("uid://du118fo2omc5e")
const LEVEL_BASE = preload("uid://ckxdufpq83pch")
const LEVELS: Array[PackedScene] = [
	preload("uid://c2d4gtx7rn56f"),
	preload("uid://cmyrnmsfrs1o8")
]

var _selected_level: int = -1
var selected_level: int:
	get:
		return _selected_level
	set(value):
		_selected_level = value
var _current_score: int = 0
var current_score: int:
	set(value):
		_current_score = value
	get:
		return _current_score

var _current_lives: int = 3
var current_lives: int:
	set(value):
		_current_lives = value
		SignalHub.emit_on_lives_change(true)
		if value == 0:
			SignalHub.emit_on_game_over()
	get:
		return _current_lives

func _exit_tree() -> void:
	ScoreManager.add_high_score(current_score)
	current_score = 0

func load_main_scene() -> void:
	get_tree().paused = false
	ScoreManager.add_high_score(current_score)
	selected_level = -1
	current_score = 0
	_current_lives = 3
	get_tree().change_scene_to_packed(MAIN)

func load_next_level() -> void:
	selected_level += 1
	if selected_level >= LEVELS.size():
		load_main_scene()
		return
	get_tree().paused = false
	get_tree().change_scene_to_packed(LEVELS[selected_level])
