class_name Main
extends Control

@onready var main_screen: MainScreen = $MainScreen
@onready var game: Game = $Game


func _ready() -> void:
	SignalHub.on_level_selected.connect(_on_level_selected)
	SignalHub.on_level_exited.connect(_on_level_exited)
	show_game(false)


func _on_level_selected(_level_setting: LevelSetting) -> void:
	show_game(true)


func _on_level_exited() -> void:
	show_game(false)


func show_game(show_game_flag: bool) -> void:
	game.visible = show_game_flag
	main_screen.visible = !show_game_flag
