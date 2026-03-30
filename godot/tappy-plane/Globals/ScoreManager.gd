extends Node

const SCORE_PATH: String = "user://tappyscore.res"

var high_score: int = 0:
	get:
		return high_score
	set(value):
		if value > high_score:
			high_score = value
			save_high_score()

func save_high_score() -> void:
	var hsr: HighScoreResource = HighScoreResource.new(high_score)
	ResourceSaver.save(hsr, SCORE_PATH)


func load_high_score() -> void:
	if ResourceLoader.exists(SCORE_PATH):
		var hsr: HighScoreResource = ResourceLoader.load(SCORE_PATH)
		if hsr and hsr.high_score:
			high_score = hsr.high_score


func _ready() -> void:
	load_high_score()
