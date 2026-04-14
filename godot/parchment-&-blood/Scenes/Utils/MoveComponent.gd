class_name MoveComponent
extends Node2D

const SMOOTH_FACTOR = 4.0
const STOP_SPEED = 1000.0

@export var speed: float = 0.0
@export var limit_to_goal: float = 0.0
var distance_to_goal: float = 0.0
var direction: Vector2 = Vector2.ZERO


func move_in_direction_with_limit(delta: float, velocity: Vector2) -> Vector2:
	if distance_to_goal <= limit_to_goal:
		return stop_movement(delta, velocity)
	else:
		return move_in_direction(delta, velocity)

func move_in_direction(delta: float, velocity: Vector2) -> Vector2:
	if direction != Vector2.ZERO:
		return lerp(velocity, direction * speed, SMOOTH_FACTOR * delta)
	else:
		return stop_movement(delta, velocity)


func stop_movement(delta: float, velocity: Vector2) -> Vector2:
	return velocity.move_toward(Vector2.ZERO, STOP_SPEED * delta)


func direction_to(goal: Vector2) -> void:
	direction = global_position.direction_to(goal)


func direction_to_or_zero(goal: Vector2, not_zero: bool) -> void:
	if not_zero:
		direction_to(goal) 
	else:
		direction = Vector2.ZERO


func orthogonal_strafe(orthogonal_factor: float) -> void:
	if direction == Vector2.ZERO:
		return
	direction = direction + (direction.orthogonal() * orthogonal_factor)
	direction = direction.normalized()


func update_limit(goal: Vector2) -> void:
	distance_to_goal = global_position.distance_to(goal)

func has_reached_limit(offset: float = 0.0) -> bool:
	return distance_to_goal <= (limit_to_goal + offset)
