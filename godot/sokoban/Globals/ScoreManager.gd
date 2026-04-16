extends Node

const SAVE_PATH: String = "user://high_scores.res"
const DEFAULT_SCORE: int = 0


var _high_scores: HighScores


func _ready() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		_high_scores = ResourceLoader.load(SAVE_PATH) as HighScores
	else:
		_high_scores = HighScores.new()


func try_add_score(level_id: String, score: int) -> bool:
	var current_best: int = _high_scores.high_scores.get(level_id, DEFAULT_SCORE)
	if current_best > score:
		_high_scores.high_scores[level_id] = score
		ResourceSaver.save(_high_scores, SAVE_PATH)
		return true
	return false


func is_completed(level_id: String) -> bool:
	return _high_scores.high_scores.has(level_id)

func get_score(level_id: String) -> int:
	return _high_scores.high_scores.get(level_id, DEFAULT_SCORE)
