class_name HighScoreDisplay
extends VBoxContainer

@onready var score_label: Label = $ScoreLabel
@onready var date_label: Label = $DateLabel
@export var high_score: HighScore = HighScore.new()

func _ready() -> void:
	modulate = Color.TRANSPARENT
	score_label.text = "%04d" % high_score.score
	date_label.text = high_score.date
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.7)

func setup(_high_score: HighScore) -> void:
	high_score = _high_score
