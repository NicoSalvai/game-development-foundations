class_name HighScores
extends Resource

const MAX_SIZE: int = 10

@export var high_scores: Array[HighScore] = []

func _init() -> void:
	high_scores.sort_custom(sort_descending)

func sort_descending(a: HighScore, b: HighScore) -> bool:
	return a.score > b.score

func add_new_score(score: int) -> void:
	if score <= 0:
		return
	var new_high_score: HighScore = HighScore.new(score, FoxyUtils.formatted_date())
	high_scores.append(new_high_score)
	high_scores.sort_custom(sort_descending)
	if high_scores.size() > MAX_SIZE:
		high_scores.resize(MAX_SIZE)
