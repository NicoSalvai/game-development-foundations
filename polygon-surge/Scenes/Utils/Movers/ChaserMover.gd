class_name ChaserMover
extends Node

@export var max_speed: float = 100.0
@export var acceleration: float = 300.0
@export var direction: Vector2 = Vector2.RIGHT

var _body: CharacterBody2D


func _ready() -> void:
	_body = get_parent() as CharacterBody2D


func move(target_pos: Vector2, delta: float) -> void:
	direction = _body.global_position.direction_to(target_pos)
	_body.velocity = _body.velocity.move_toward(
		direction * max_speed,
		acceleration * delta
	)
