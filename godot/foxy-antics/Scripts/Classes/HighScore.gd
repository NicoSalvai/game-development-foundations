class_name HighScore
extends Resource

@export var score: int = 0
@export var date: String = FoxyUtils.formatted_date()

func _init(_score: int = 0, _date: String = FoxyUtils.formatted_date()) -> void:
	score = _score
	date = _date
