class_name TankMover
extends Node

@export var drift_speed: float = 60.0
@export var wander_strength: float = 80.0
@export var wander_interval: float = 1.5
@export var acceleration: float = 150.0

var _body: CharacterBody2D
var _wander_direction: Vector2 = Vector2.ZERO
var _wander_timer: float = 0.0


func _ready() -> void:
	_body = get_parent() as CharacterBody2D
	_wander_direction = Vector2.from_angle(randf() * TAU)
	_wander_timer = randf_range(0.0, wander_interval)


func move(target_pos: Vector2, delta: float) -> void:
	_wander_timer += delta
	if _wander_timer >= wander_interval:
		_wander_timer = 0.0
		_wander_direction = Vector2.from_angle(randf() * TAU)

	var drift := _body.global_position.direction_to(target_pos) * drift_speed
	var wander := _wander_direction * wander_strength
	var target_velocity := (drift + wander).limit_length(drift_speed + wander_strength)

	_body.velocity = _body.velocity.move_toward(target_velocity, acceleration * delta)
