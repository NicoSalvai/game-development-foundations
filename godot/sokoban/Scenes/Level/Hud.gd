class_name HUD
extends Control

@onready var game_over_panel: PanelContainer = $GameOverPanel
@onready var exit_button: CustomButton = $MarginContainer/VBoxContainer/ExitButton
@onready var restart_button: CustomButton = $MarginContainer/VBoxContainer/RestartButton
@onready var best_label: Label = $MarginContainer/VB/HBBest/BestLabel
@onready var moves_label: Label = $MarginContainer/VB/HBMoves/MovesLabel
@onready var level_label: Label = $MarginContainer/VB/HBLevel/LevelLabel

func _ready() -> void:
	game_over_panel.hide()
	exit_button.function = GameManager.load_main
	restart_button.function = GameManager.load_level
	best_label.text = "%02d" % ScoreManager.get_score(GameManager.current_level) \
		if ScoreManager.is_completed(GameManager.current_level) else "-"
	level_label.text = "%02d" % GameManager.current_level
	set_moves_label(0)


func _on_game_over() -> void:
	game_over_panel.show()

func set_moves_label(moves: int) -> void:
	moves_label.text = "%02d" % moves
