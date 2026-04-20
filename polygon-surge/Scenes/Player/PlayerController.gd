class_name PlayerController
extends Node2D


const STICK_DEAD_ZONE: float = 0.4
const STICK_AIM_RADIUS: float = 300.0

@export var player_controls: PlayerControls = PlayerControls.new()

var direction: Vector2 = Vector2.ZERO
var aim_target: Vector2 = Vector2.RIGHT
var dash_pressed: bool = false
var shoot_pressed: bool = false
var _using_game_pad: bool = false

var _last_stick: Vector2 = Vector2.RIGHT

func _physics_process(_delta: float) -> void:
	direction = _update_direction()
	aim_target = _update_aim_target()
	dash_pressed = Input.is_action_just_pressed(player_controls.action_dash)
	shoot_pressed = Input.is_action_pressed(player_controls.action_shoot)


func _update_direction() -> Vector2:
	return Input.get_vector(
		player_controls.action_left, player_controls.action_right,
		player_controls.action_up, player_controls.action_down
	).normalized()


# TODO: Review how to choose between gamepad and mouse
func _update_aim_target() -> Vector2:
	var stick := Input.get_vector(
		player_controls.action_look_left, player_controls.action_look_right,
		player_controls.action_look_up, player_controls.action_look_down
	)
	if stick.length() > STICK_DEAD_ZONE:
		_using_game_pad = true
		_last_stick = stick
		return global_position + stick * STICK_AIM_RADIUS
	
	if !_using_game_pad || Input.get_last_mouse_velocity().length() > 0.0:
		return get_global_mouse_position()
	else:
		return global_position + _last_stick * STICK_AIM_RADIUS
