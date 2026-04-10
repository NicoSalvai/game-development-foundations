extends Node

const HIGH_SCORES_PATH: String = "user://high_scores_foxy.tres"
var high_scores: HighScores


func get_high_scores() -> HighScores:
	if !high_scores:
		high_scores = load_high_scores()
	return high_scores


func load_high_scores() -> HighScores:
	if ResourceLoader.exists(HIGH_SCORES_PATH):
		var hs: HighScores = ResourceLoader.load(HIGH_SCORES_PATH)
		if hs:
			return hs
	return HighScores.new()


func add_high_score(score: int) -> void:
	high_scores.add_new_score(score)
	ResourceSaver.save(high_scores, HIGH_SCORES_PATH)
