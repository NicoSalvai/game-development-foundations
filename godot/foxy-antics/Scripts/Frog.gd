class_name Frog
extends EnemyBase

const JUMP_VELOCITY: Vector2 = Vector2(100, -150)

@onready var jump_timer: Timer = $JumpTimer

var _can_jump: bool = false
var _seen_player: bool = false


func _physics_process(delta: float) -> void:
	handle_flip()
	handle_movement()
	handle_jump()
	handle_gravity(delta)
	super._physics_process(delta)


func handle_movement() -> void:
	animated_sprite_2d.flip_h = true if direction > 0.0 else false
	if is_on_floor():
		animated_sprite_2d.play("idle")
		velocity.x = 0.0


func handle_jump() -> void:
	if !is_on_floor() or !_can_jump or !_seen_player:
		return

	velocity = JUMP_VELOCITY * Vector2(direction, 1.0) 
	animated_sprite_2d.play("jump")
	_can_jump = false
	start_timer()


func handle_flip() -> void:
	if _player_ref.global_position.x > global_position.x:
		direction = 1.0
	else:
		direction = -1.0


func start_timer() -> void:
	jump_timer.start(randf_range(2.0, 3.0))


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if !_seen_player:
		_seen_player = true
		start_timer()


func _on_jump_timer_timeout() -> void:
	_can_jump = true
