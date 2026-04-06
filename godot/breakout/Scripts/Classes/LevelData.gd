class_name LevelData
extends Resource

@export var columns: int = 10
@export var bricks: Array[BrickDefinition] = []
var rows: int:
	get: return bricks.size() / columns
