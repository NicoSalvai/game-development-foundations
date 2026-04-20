class_name PlayerController
extends Node2D


@export var action_left: StringName = "left"
@export var action_right: StringName = "right"
@export var action_up: StringName = "up"
@export var action_down: StringName = "down"
@export var action_look_left: StringName = "look_left"
@export var action_look_right: StringName = "look_right"
@export var action_look_up: StringName = "look_up"
@export var action_look_down: StringName = "look_down"
@export var action_dash: StringName = "dash"
@export var stick_dead_zone: float = 0.4
@export var stick_aim_radius: float = 300.0

var direction: Vector2 = Vector2.ZERO
var aim_target: Vector2 = Vector2.RIGHT
var dash_pressed: bool = false

var _last_stick: Vector2 = Vector2.RIGHT

func _physics_process(_delta: float) -> void:
	direction = _update_direction()
	aim_target = _update_aim_target()
	dash_pressed = Input.is_action_just_pressed(action_dash)


func _update_direction() -> Vector2:
	return Input.get_vector(
		action_left, action_right,
		action_up, action_down
	).normalized()


func _update_aim_target() -> Vector2:
	var stick := Input.get_vector(
		action_look_left, action_look_right,
		action_look_up, action_look_down
	)
	if stick.length() > stick_dead_zone:
		_last_stick = stick
		return global_position + stick * stick_aim_radius
	
	if Input.get_last_mouse_velocity().length() > 0.0:
		return get_global_mouse_position()
	else:
		return global_position + _last_stick * stick_aim_radius
