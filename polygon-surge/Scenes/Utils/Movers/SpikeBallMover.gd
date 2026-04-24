class_name SpikeBallMover
extends Node

enum State { IDLE, WINDUP, CHARGE, RECOVER }

@export var idle_speed: float = 40.0
@export var idle_duration: float = 2.0
@export var windup_duration: float = 0.8
@export var max_spin_speed: float = 15.0
@export var spin_acceleration: float = 20.0
@export var charge_speed: float = 400.0
@export var charge_max_distance: float = 300.0
@export var recover_duration: float = 0.8

var _state: State = State.IDLE
var _timer: float = 0.0
var _spin_speed: float = 0.0
var _charge_direction: Vector2 = Vector2.ZERO
var _charge_distance: float = 0.0
var _body: CharacterBody2D


func _ready() -> void:
	_body = get_parent() as CharacterBody2D
	_timer = idle_duration


func move(target_pos: Vector2, delta: float) -> void:
	_timer -= delta
	match _state:
		State.IDLE:
			var direction := _body.global_position.direction_to(target_pos)
			_body.velocity = _body.velocity.move_toward(
				direction * idle_speed, 200.0 * delta
			)
			if _timer <= 0.0:
				_enter_windup()

		State.WINDUP:
			var direction := _body.global_position.direction_to(target_pos)
			_body.velocity = _body.velocity.move_toward(
				direction * idle_speed, 200.0 * delta
			)
			_spin_speed = move_toward(_spin_speed, max_spin_speed, spin_acceleration * delta)
			if _timer <= 0.0:
				_enter_charge(target_pos)

		State.CHARGE:
			_body.velocity = _charge_direction * charge_speed
			_charge_distance += charge_speed * delta
			# rebote con paredes
			if _body.get_slide_collision_count() > 0:
				for i in _body.get_slide_collision_count():
					var collision := _body.get_slide_collision(i)
					if not collision.get_collider() is CharacterBody2D:
						_charge_direction = _charge_direction.bounce(collision.get_normal())
			if _charge_distance >= charge_max_distance:
				_enter_recover()

		State.RECOVER:
			_body.velocity = _body.velocity.move_toward(Vector2.ZERO, 600.0 * delta)
			_spin_speed = move_toward(_spin_speed, 0.0, spin_acceleration * delta)
			if _timer <= 0.0:
				_enter_idle()


func on_player_hit() -> void:
	if _state == State.CHARGE:
		_enter_recover()


func get_state() -> State:
	return _state


func get_spin_speed() -> float:
	return _spin_speed


func _enter_idle() -> void:
	_state = State.IDLE
	_timer = idle_duration


func _enter_windup() -> void:
	_state = State.WINDUP
	_timer = windup_duration
	_spin_speed = 0.0


func _enter_charge(target_pos: Vector2) -> void:
	_state = State.CHARGE
	_charge_direction = _body.global_position.direction_to(target_pos)
	_charge_distance = 0.0


func _enter_recover() -> void:
	_state = State.RECOVER
	_timer = recover_duration
