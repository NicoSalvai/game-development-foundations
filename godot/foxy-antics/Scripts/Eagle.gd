extends EnemyBase

@onready var player_detector: RayCast2D = $PlayerDetector
@onready var turn_timer: Timer = $TurnTimer
@onready var shooter: Shooter = $Shooter

@export var fly_speed: Vector2 = Vector2(35, 15)

var _fly_direction: Vector2 = Vector2.ZERO
var _seen_player: bool = false


func _physics_process(delta: float) -> void:
	handle_shooting()
	super._physics_process(delta)


func handle_movement() -> void:
	velocity = _fly_direction 
	animated_sprite_2d.flip_h = true if velocity.x > 0 else false


func handle_flip() -> void:
	if _player_ref.global_position.x > global_position.x:
		direction = 1.0
	else:
		direction = -1.0
	_fly_direction = fly_speed * Vector2(direction, 1.0)

func handle_shooting() -> void:
	if _seen_player and player_detector.is_colliding():
		var dir: Vector2 = global_position.direction_to(_player_ref.global_position)
		shooter.shoot(dir)


func _on_turn_timer_timeout() -> void:
	handle_flip()
	handle_movement()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play()
	turn_timer.start()
	handle_flip()
	handle_movement()
	_seen_player = true
