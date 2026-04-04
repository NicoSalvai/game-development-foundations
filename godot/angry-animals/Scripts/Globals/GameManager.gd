extends Node

const MAIN = preload("uid://cs25yy3dbkrts")


func load_level_scene(level_number: int) -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelBase/Level%d.tscn" % level_number)

func load_main_scene() -> void:
	get_tree().change_scene_to_packed(MAIN)
