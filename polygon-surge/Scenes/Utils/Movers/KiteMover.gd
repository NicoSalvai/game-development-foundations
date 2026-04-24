class_name KiteMover
extends Node

@export var min_range: float = 150.0
@export var max_range: float = 250.0
@export var max_speed: float = 80.0
@export var acceleration: float = 200.0

var _body: CharacterBody2D


func _ready() -> void:
	_body = get_parent() as CharacterBody2D


func move(target_pos: Vector2, delta: float) -> void:
	var distance := _body.global_position.distance_to(target_pos)
	var direction: Vector2

	if distance < min_range:
		direction = target_pos.direction_to(_body.global_position)
	elif distance > max_range:
		direction = _body.global_position.direction_to(target_pos)
	else:
		_body.velocity = _body.velocity.move_toward(Vector2.ZERO, acceleration * delta)
		return

	_body.velocity = _body.velocity.move_toward(
		direction * max_speed,
		acceleration * delta
	)
