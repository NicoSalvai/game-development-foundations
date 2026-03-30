extends Node

const MAIN = preload("uid://dp8sqrwh8i225")
const GAME = preload("uid://kxcjvt8uxkx7")
#const SIMPLE_TRANSITION = preload("uid://v0e1coifjli3")
const COMPLEX_TRANSITION = preload("uid://cww23r813fq7h")

var next_scene: PackedScene
var cx: ComplexTransition

func _ready() -> void:
	cx = COMPLEX_TRANSITION.instantiate()
	add_child(cx)

func load_main_scene() -> void:
	next_scene = MAIN
	cx.play_animation()
	#get_tree().change_scene_to_packed(SIMPLE_TRANSITION)
	
	
func load_game_scene() -> void:
	next_scene = GAME
	cx.play_animation()
	#get_tree().change_scene_to_packed(SIMPLE_TRANSITION)

func load_next_scene() -> void:
	get_tree().change_scene_to_packed(next_scene)
