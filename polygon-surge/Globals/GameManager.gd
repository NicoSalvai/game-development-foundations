extends Node


const TARGET = preload("uid://drbbrurxxv0oo")
const POINTER_SCIFI = preload("uid://xbd5rccg03qx")

const LEVELS: Dictionary[int, PackedScene] = {
	1: preload("uid://w8iml5o1oq4r"),
	2: preload("uid://cjgtvpyjbcp51"),
	3: preload("uid://drkveleiwf0g2"),
	4: preload("uid://b8sdabwbrwuh5"),
	5: null,
}

const MAIN_SCENE: PackedScene = preload("uid://col3etgeo7lt7")
const MAP_SCENE: PackedScene = preload("uid://5s3a15l27enm")
const TECH_TREE_SCENE = preload("uid://dw21uejx6473i")

var _selected_level: int = 1

func load_main_scene() -> void:
	UIAudioManager.play_ui_music()
	set_cursor()
	load_scene(MAIN_SCENE)


func load_tech_tree_scene() -> void:
	UIAudioManager.play_ui_music()
	set_cursor()
	load_scene(TECH_TREE_SCENE)
	
	
func load_map_scene() -> void:
	UIAudioManager.play_ui_music()
	set_cursor()
	load_scene(MAP_SCENE)


func load_level_scene(level: int) -> void:
	if LEVELS.has(level):
		_selected_level = level
		load_selected_level_scene()


func load_selected_level_scene() -> void:
	UIAudioManager.stop_ui_music()
	set_cursor(false)
	load_scene(LEVELS[_selected_level])


func load_scene(scene: PackedScene) -> void:
	SceneTransition.transition_to(scene)  


func set_cursor(is_pointer: bool = true) -> void:
	if is_pointer:
		Input.set_custom_mouse_cursor(POINTER_SCIFI, Input.CURSOR_ARROW, Vector2(0, 0))
	else:
		Input.set_custom_mouse_cursor(TARGET, Input.CURSOR_ARROW, Vector2(32, 32))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
