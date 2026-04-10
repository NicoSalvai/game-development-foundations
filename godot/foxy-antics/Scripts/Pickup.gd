class_name Pickup
extends Area2D

@export var points: int = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound: AudioStreamPlayer2D = $Sound

func _ready() -> void:
	var animation_names: Array[String] = []
	for anim_name in animated_sprite_2d.sprite_frames.get_animation_names():
		animation_names.push_back(anim_name)
	animated_sprite_2d.play(animation_names.pick_random())


func setup(pos: Vector2, _points: int) -> void:
	position = pos
	points = _points


func _on_area_entered(_area: Area2D) -> void:
	hide()
	set_deferred("monitoring", false)
	sound.play()
	sound.finished.connect(queue_free)
	SignalHub.emit_on_points_scored(points)
