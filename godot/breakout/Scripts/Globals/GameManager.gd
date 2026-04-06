extends Node

enum GameState {WON, LOST, PLAYING, PAUSED}
const LEVEL_BASE = preload("uid://o8skjhu0xv6d")
const MAIN = preload("uid://b202l1ov5s5yg")

var game_state: GameState = GameState.PAUSED
var _selected_level: int = 1
var selected_level: int:
	get: 
		return _selected_level
	set(value):
		_selected_level = max(0, value)

func _ready() -> void:
	SignalHub.won_game.connect(_on_won_game)
	SignalHub.lost_game.connect(_on_lost_game)

func load_level_scene() -> void:
	get_tree().change_scene_to_packed(LEVEL_BASE)
	game_state = GameState.PLAYING

func load_main_scene() -> void:
	get_tree().change_scene_to_packed(MAIN)
	game_state = GameState.PAUSED

func _on_won_game() -> void:
	game_state = GameState.WON

func _on_lost_game() -> void:
	game_state = GameState.LOST
