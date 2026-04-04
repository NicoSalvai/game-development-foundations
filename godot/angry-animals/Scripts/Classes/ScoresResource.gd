class_name ScoresResource

extends Resource


const DEFAULT: int = 0


@export var level_scores: Dictionary[int, int] = {}


func get_level_best(level: int) -> int:
	return level_scores.get(level, DEFAULT)


func try_set_level_best(level: int, score: int) -> void:
	if get_level_best(level) == 0 or get_level_best(level) > score:
		level_scores[level] = score
