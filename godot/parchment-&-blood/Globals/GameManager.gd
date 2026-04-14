extends Node

const MAIN = preload("uid://bhmkere5244cv")
const CREDITS = preload("res://Scenes/Credits/Credits.tscn")
const LEVELS: Array[PackedScene] = [
	preload("uid://bdni7pkykkcak"),
	preload("uid://dybx28b1d3ke0"),
	preload("uid://polhfmhpama5")
]

var selected_level: int = 0


func load_main_scene() -> void:
	get_tree().paused = false
	selected_level = 0
	get_tree().change_scene_to_packed(MAIN)

func load_level() -> void:
	get_tree().paused = false
	if selected_level >= len(LEVELS):
		load_credits_scene()
		return
	get_tree().change_scene_to_packed(LEVELS[selected_level])


func load_next_level() -> void:
	selected_level = selected_level + 1
	load_level()


func load_credits_scene() -> void:
	selected_level = 0
	get_tree().change_scene_to_packed(CREDITS)
