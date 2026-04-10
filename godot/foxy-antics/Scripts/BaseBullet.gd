class_name BaseBullet
extends Area2D

@export var _velocity: Vector2 = Vector2(50, -50)

func _process(delta: float) -> void:
	global_position += _velocity * delta

func _on_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()

func setup(_position: Vector2, direction: Vector2, speed: float) -> void:
	position = _position
	_velocity = direction.normalized() * speed
