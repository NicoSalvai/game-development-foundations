class_name KiteMover
extends Node

@export var min_range: float = 150.0
@export var max_range: float = 250.0
@export var max_speed: float = 80.0
@export var acceleration: float = 200.0
@export var strafe_interval: float = 2.0

var _body: CharacterBody2D
var _strafe_direction: float = 1.0  # 1.0 derecha, -1.0 izquierda
var _strafe_timer: float = 0.0


func _ready() -> void:
	_body = get_parent() as CharacterBody2D
	_strafe_direction = 1.0 if randf() > 0.5 else -1.0
	_strafe_timer = randf_range(0.0, strafe_interval)  # desincroniza múltiples shooters


func move(target_pos: Vector2, delta: float) -> void:
	_strafe_timer += delta
	if _strafe_timer >= strafe_interval:
		_strafe_timer = 0.0
		_strafe_direction *= -1.0

	var distance := _body.global_position.distance_to(target_pos)
	var direction: Vector2

	if distance < min_range:
		direction = target_pos.direction_to(_body.global_position)
	elif distance > max_range:
		direction = _body.global_position.direction_to(target_pos)
	else:
		var to_player := _body.global_position.direction_to(target_pos)
		direction = Vector2(-to_player.y, to_player.x) * _strafe_direction

	_body.velocity = _body.velocity.move_toward(
		direction * max_speed,
		acceleration * delta
	)
