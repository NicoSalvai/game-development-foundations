extends Node


const SCORE_PATH: String = "user://angryanimalsscore.res"


var scores: ScoresResource


var level_selected: int = 1


func _ready() -> void:
	load_scores()


func set_score_for_current_level(score: int) -> void:
	scores.try_set_level_best(level_selected, score)
	save_scores()


func get_level_best(level: int) -> int:
	return scores.get_level_best(level)


func load_scores() -> void:
	if ResourceLoader.exists(SCORE_PATH):
		var sr = ResourceLoader.load(SCORE_PATH)
		if sr and sr is ScoresResource:
			scores = sr
	else:
		scores = ScoresResource.new()


func save_scores() -> void:
	ResourceSaver.save(scores, SCORE_PATH)
