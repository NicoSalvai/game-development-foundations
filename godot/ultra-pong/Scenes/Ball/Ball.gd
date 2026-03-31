extends CharacterBody2D


class_name Ball


signal ball_exited_screen(direction: float)


const MAX_SPEED: float = 1000.0


@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


var speed_increment_on_hit: float = 0.0:
	set(value): 
		speed_increment_on_hit = clamp(value, 0.0, 100.0)


func launch(initial_speed: float, direction: Vector2) -> void:
	velocity = Vector2(direction.x * initial_speed, direction.y * initial_speed)

func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(_on_ball_exited_screen)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		position += collision.get_normal() * 1.0
		if collision.get_collider() is WorldBorders:
			velocity = velocity.bounce(collision.get_normal())
		elif collision.get_collider() is Paddle:
			velocity = _handle_paddle_collision(collision.get_collider() as Paddle)


func _handle_paddle_collision(paddle: Paddle) -> Vector2:
	var collision_y_influence = (position.y - paddle.position.y) / paddle.get_height()
	var paddle_velocity_influence = paddle.velocity.y * 0.01
	
	var y_module = clamp(collision_y_influence + paddle_velocity_influence, -1.0, 1.0)
	
	var direction: Vector2 = Vector2(-sign(velocity.x), y_module).normalized()
	var magnitude: float = min(velocity.length() + speed_increment_on_hit, MAX_SPEED)
	
	return Vector2(direction.x * magnitude , direction.y * magnitude)

func _on_ball_exited_screen() -> void:
	var screen_width = get_viewport_rect().size.x
	var direction = -1 if position.x < screen_width / 2 else 1
	ball_exited_screen.emit(direction)
	queue_free()
