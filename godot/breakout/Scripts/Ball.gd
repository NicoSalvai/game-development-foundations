class_name Ball
extends CharacterBody2D

const GROUP_NAME: String = "Ball"
const DEFAULT_DIRECTION: Vector2 = Vector2.UP
enum BallState {ATTACHED, RUNNING}

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var _speed: float = 350.0
@export var damage: int = 1
@export var _ball_state: BallState = BallState.ATTACHED
var paddle: Paddle


func _ready() -> void:
	add_to_group(GROUP_NAME)
	visible_on_screen_notifier_2d.screen_exited.connect(handle_exited_screen, CONNECT_ONE_SHOT)
	if paddle:
		paddle.ball_launched = false


func _physics_process(delta: float) -> void:
	if _ball_state == BallState.ATTACHED:
		if not paddle:
			return
		position.x = paddle.position.x
		handle_ball_launched()
	else:
		handle_physics_movement(delta)


func handle_physics_movement(delta: float):
	var collision = move_and_collide(velocity * delta)
	if collision:
		position += collision.get_normal() * 1.0
		if collision.get_collider().has_method("on_ball_collision"):
			collision.get_collider().on_ball_collision(self, collision)
		else:
			handle_default_collision(collision)


func handle_default_collision(collision: KinematicCollision2D) -> void:
	velocity = velocity.bounce(collision.get_normal()).normalized() * _speed


func handle_paddle_collision(collision_paddle: Paddle, collision: KinematicCollision2D) -> void:
	var half_paddle_width = collision_paddle.get_width() / 2.0
	var impact_offset = collision.get_position().x - collision_paddle.global_position.x
	var collision_x_influence = clamp(impact_offset / half_paddle_width, -1.0, 1.0)
	var direction = Vector2(collision_x_influence, -1.0).normalized()
	velocity = direction * _speed


func handle_exited_screen() -> void:
	SignalHub.ball_died.emit()
	queue_free()


func launch(direction: Vector2 = DEFAULT_DIRECTION) -> void:
	velocity = direction * _speed
	_ball_state = BallState.RUNNING


func handle_ball_launched() -> void:
	if paddle.ball_launched:
		launch()
		paddle.ball_launched = false
