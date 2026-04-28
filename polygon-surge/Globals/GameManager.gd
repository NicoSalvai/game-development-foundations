extends Node


const LEVELS: Dictionary[int, PackedScene] = {
	1: preload("uid://w8iml5o1oq4r"),
	2: preload("uid://cjgtvpyjbcp51"),
	3: preload("uid://drkveleiwf0g2"),
	4: null,
	5: null,
}

const MAIN_SCENE: PackedScene = preload("uid://col3etgeo7lt7")
const MAP_SCENE: PackedScene = preload("uid://5s3a15l27enm")

var _selected_level: int = 1

func load_main_scene() -> void:
	load_scene(MAIN_SCENE)
	
	
func load_map_scene() -> void:
	load_scene(MAP_SCENE)


func load_level_scene(level: int) -> void:
	if LEVELS.has(level):
		_selected_level = level
		load_selected_level_scene()


func load_selected_level_scene() -> void:
	load_scene(LEVELS[_selected_level])


func load_scene(scene: PackedScene) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(scene)
