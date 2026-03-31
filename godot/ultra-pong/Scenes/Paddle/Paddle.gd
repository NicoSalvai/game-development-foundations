extends CharacterBody2D

class_name Paddle

const MAX_SPEED: float = 500.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var direction: float = 0.0
var acceleration: float = 1000.0
var friction: float = 500.0
var up_input: String
var down_input: String


func setup(_flip: bool, _position: Vector2, _up_input: String, _down_input: String) -> void:
	if _flip:
		collision_shape_2d.position.x *= -1.0
	up_input = _up_input
	down_input = _down_input
	position = _position

func _physics_process(delta: float) -> void:
	direction = get_direction_input()
	update_velocity(delta)
	move_and_slide()


func update_velocity(delta: float) -> void:
	if (!is_zero_approx(direction)):
		velocity.y = move_toward(velocity.y, direction * MAX_SPEED, acceleration * delta)
	elif !is_zero_approx(velocity.y):
		velocity.y = move_toward(velocity.y, 0, friction * delta)


func get_direction_input() -> float:
	return Input.get_axis(up_input, down_input)


func get_height() -> float:
	var shape = collision_shape_2d.shape as RectangleShape2D
	return shape.size.y / 2.0
