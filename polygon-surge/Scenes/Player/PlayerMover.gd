class_name PlayerMover
extends Node


const MAX_SPEED: float = 300.0
const ACCELERATION: float = 800.0
const FRICTION: float = 1600.0


var _body: CharacterBody2D


func _ready() -> void:
	_body = get_parent() as CharacterBody2D


func move(dir: Vector2, delta: float) -> void:
	if dir != Vector2.ZERO:
		_body.velocity = _body.velocity.move_toward(
			dir * MAX_SPEED,
			ACCELERATION * delta
		)
	else:
		_body.velocity = _body.velocity.move_toward(
			Vector2.ZERO,
			FRICTION * delta
		)
	# This is here to clamp the velocity after a "Dash" -> Recondier if move is enabled during "dash"
	_body.velocity = _body.velocity.limit_length(MAX_SPEED)
