class_name Cup


extends StaticBody2D

const GROUP_NAME: String = "Cup"
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _enter_tree() -> void:
	add_to_group(GROUP_NAME)

func die() -> void:
	animation_player.play("vanish")
	animation_player.animation_finished.connect(_on_animation_finished)
	SignalHub.emit_on_cup_destroyed()


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "vanish":
		queue_free()
