class_name ArcherEnemy
extends Enemy


const DISTANCE_TO_PLAYER_LIMIT = 500.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Shooter = $Shooter
@onready var debug_label: Label = $DebugLabel


var _is_aiming: bool = false
var _finished_aiming: bool = false
var _direction: Vector2 = Vector2.ZERO
var _speed: float = 100.0
var _orthogonal_speed_factor: float = 0.0
var _distance_to_player: float = 500.0

func _ready() -> void:
	super._ready()
	animation_player.animation_finished.connect(_on_animation_finished)
	_orthogonal_speed_factor = randf_range(-1.0, 1.0)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_distance_to_player = global_position.distance_to(_player_ref.global_position)
	handle_shoot()
	handle_aiming()
	handle_direction()
	handle_movement(delta)
	move_and_slide()


func handle_movement(delta: float) -> void:
	if _direction != Vector2.ZERO and _distance_to_player > DISTANCE_TO_PLAYER_LIMIT:
		velocity = lerp(velocity, _direction * _speed, SMOOTH_FACTOR * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, STOP_SPEED * delta)


func handle_direction() -> void:
	if _sees_player:
		var straight_direction = global_position.direction_to(_player_ref.global_position)
		_direction = straight_direction + (straight_direction.orthogonal() * _orthogonal_speed_factor)
		_direction = _direction.normalized()
	else:
		_direction = Vector2.ZERO


func handle_shoot() -> void:
	if _finished_aiming and _is_aiming:
		shoot()


func shoot() -> void:
	shooter.shoot(_player_ref.global_position)
	animation_player.play("Archer/re_aim")
	_finished_aiming = false


func handle_aiming() -> void:
	if _sees_player and !_is_aiming and _distance_to_player <= DISTANCE_TO_PLAYER_LIMIT:
		animation_player.play("Archer/aim")
		_is_aiming = true
	elif !_sees_player and _is_aiming:
		_is_aiming = false
		_finished_aiming = false
		animation_player.play("Archer/RESET")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name in ["Archer/aim", "Archer/re_aim"]:
		_finished_aiming = true
