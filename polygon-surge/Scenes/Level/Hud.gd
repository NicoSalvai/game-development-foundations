class_name HUD
extends Control



@onready var margin_container: MarginContainer = $MarginContainer
@onready var v_box_game_over: VBoxContainer = $MarginContainer/HUDPanel/MarginContainer/VBoxGameOver
@onready var v_box_victory: VBoxContainer = $MarginContainer/HUDPanel/MarginContainer/VBoxVictory
@onready var v_box_pause: VBoxContainer = $MarginContainer/HUDPanel/MarginContainer/VBoxPause

var _paused: bool = false

func _ready() -> void:
	margin_container.visible = false
	v_box_game_over.visible = false
	v_box_victory.visible = false
	v_box_pause.visible = false
	SignalHub.game_over.connect(show_game_over)
	SignalHub.level_cleared.connect(show_victory)

func show_game_over() -> void:
	get_tree().paused = true
	margin_container.visible = true
	v_box_game_over.visible = true


func show_victory() -> void:
	get_tree().paused = true
	margin_container.visible = true
	v_box_victory.visible = true
	GameState.set_completed(GameManager._selected_level)


func pause_game(flag: bool = false) -> void:
	get_tree().paused = flag
	margin_container.visible = flag
	v_box_pause.visible = flag
	_paused = flag


func _on_map_pressed() -> void:
	GameManager.load_map_scene()


func _on_restart_pressed() -> void:
	GameManager.load_selected_level_scene()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _paused:
			pause_game(false)
		else:
			pause_game(true)
