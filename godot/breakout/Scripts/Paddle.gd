class_name Paddle


extends CharacterBody2D


const MAX_VELOCITY: float = 800.0


var _acceleration: float = 1000.0
var _friction: float = 750.0
var ball_launched: bool:
	get: 
		return controller.launch_ball
	set(value):
		controller.launch_ball = value

@onready var controller: Node = $PlayerController
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	_update_velocity(delta)
	move_and_slide()


func _update_velocity(delta: float) -> void:
	if is_zero_approx(controller.direction):
		handle_inertia_motion(delta)
	elif is_zero_approx(velocity.x) or controller.direction == sign(velocity.x):
		handle_accelerate_motion(delta)
	else:
		handle_stop_motion(delta)


func handle_inertia_motion(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, _friction * delta)


func handle_accelerate_motion(delta: float) -> void:
	velocity.x = move_toward(velocity.x, MAX_VELOCITY * controller.direction, _acceleration * delta)


func handle_stop_motion(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, (_acceleration + _friction) * delta)


func get_width() -> float:
	var shape = collision_shape_2d.shape as RectangleShape2D
	return shape.size.x

func on_ball_collision(ball: Ball, collision: KinematicCollision2D) -> void:
	ball.handle_paddle_collision(self, collision)
