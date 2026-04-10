class_name Explosion
extends Node2D

@onready var sound: AudioStreamPlayer2D = $Sound

func _ready() -> void:
	sound.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	hide()
	queue_free()

func setup(pos: Vector2) -> void:
	position = pos
