class_name Main
extends Control

const HIGH_SCORE_DISPLAY = preload("uid://dvwy5n1pvtcvt")
@onready var grid_container: GridContainer = $MarginContainer/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	load_high_scores()


func load_high_scores() -> void:
	var high_scores: HighScores = ScoreManager.get_high_scores()
	for high_score in high_scores.high_scores:
		var high_score_display: HighScoreDisplay = HIGH_SCORE_DISPLAY.instantiate()
		high_score_display.setup(high_score)
		grid_container.add_child(high_score_display)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("next"):
		GameManager.load_next_level()
