extends Node

var current_level: String = ""
const LEVEL = preload("uid://3erogswmru6e")
const MAIN = preload("uid://dt12mjj45tb81")

func set_level(level: String) -> void:
	if level in LevelData.all_level_data:
		current_level = level
		LevelData.load_level_data(level)
		load_level()

func load_main() -> void:
	get_tree().change_scene_to_packed(MAIN)

func load_level() -> void:
	get_tree().change_scene_to_packed(LEVEL)
