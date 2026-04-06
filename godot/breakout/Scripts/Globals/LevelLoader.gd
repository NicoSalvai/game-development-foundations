extends Node


# Esto es muy rigido, se puede mejorar
const PATH_TO_LEVELS: String = "res://Resources/Levels/Level%d.tres"

func load_level(level_number: int) -> LevelData:
	if ResourceLoader.exists(PATH_TO_LEVELS % level_number):
		var level = ResourceLoader.load(PATH_TO_LEVELS % level_number)
		if level is LevelData:
			return level
	return null
