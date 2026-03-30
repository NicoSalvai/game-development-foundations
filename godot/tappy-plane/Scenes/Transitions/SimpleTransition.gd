extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(1.0).timeout.connect(_next_scene)

func _next_scene() -> void:
	GameManager.load_next_scene()
