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
	_open_ui()
	v_box_game_over.visible = true


func show_victory() -> void:
	_open_ui()
	v_box_victory.visible = true
	GameState.set_completed(GameManager._selected_level)


func pause_game() -> void:
	_open_ui()
	v_box_pause.visible = true
	_paused = true
	
func unpause_game() -> void:
	_open_ui(false)
	v_box_pause.visible = false
	_paused = false


func _on_map_pressed() -> void:
	GameManager.load_map_scene()


func _on_restart_pressed() -> void:
	GameManager.load_selected_level_scene()


func _open_ui(open: bool = true) -> void:
	get_tree().paused = open
	margin_container.visible = open
	GameManager.set_cursor(open)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _paused:
			unpause_game()
		else:
			pause_game()
