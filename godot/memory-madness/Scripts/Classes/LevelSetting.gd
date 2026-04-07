class_name LevelSetting
extends Resource

@export var rows: int = 2
@export var cols: int = 2


var target_pairs: int:
	get: return total_tiles / 2

var total_tiles: int:
	get: return rows * cols


func _to_string() -> String:
	return "%dx%d" % [rows, cols]


func _init(_rows: int, _cols: int) -> void:
	rows = _rows
	cols = _cols
