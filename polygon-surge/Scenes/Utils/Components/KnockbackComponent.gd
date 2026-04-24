class_name KnockbackComponent
extends Node

@export var impulse_strength: float = 400.0
@export var decay: float = 1800.0

var is_active: bool = false

var _knockback_velocity: Vector2 = Vector2.ZERO


func apply(direction: Vector2, strength: float) -> void:
	is_active = true
	_knockback_velocity = direction * strength


func cancel() -> void:
	_knockback_velocity = Vector2.ZERO
	is_active = false


func get_velocity() -> Vector2:
	return _knockback_velocity


func _physics_process(delta: float) -> void:
	if not is_active:
		return
	_knockback_velocity = _knockback_velocity.move_toward(Vector2.ZERO, decay * delta)
	if _knockback_velocity.is_zero_approx():
		is_active = false
