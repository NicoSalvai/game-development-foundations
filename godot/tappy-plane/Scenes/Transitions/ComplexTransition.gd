extends CanvasLayer

class_name ComplexTransition

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_animation() -> void:
	animation_player.play("fade")


func switch_scene() -> void:
	GameManager.load_next_scene()
