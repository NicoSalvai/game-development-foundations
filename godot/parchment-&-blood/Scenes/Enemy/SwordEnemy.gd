class_name SwordEnemy
extends Enemy

const DISTANCE_TO_PLAYER_LIMIT = 50.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debug_label: Label = $DebugLabel

var _direction: Vector2 = Vector2.ZERO
var _speed: float = 200.0
var _distance_to_player: float = 100.0
var _is_attacking: bool = false

func _ready() -> void:
	super._ready()
	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_distance_to_player = global_position.distance_to(_player_ref.global_position)
	handle_direction()
	handle_movement(delta)
	handle_attack()
	move_and_slide()
	debug_label.text = "DP %s" % [_distance_to_player]


func handle_movement(delta: float) -> void:
	if _direction != Vector2.ZERO and _distance_to_player > DISTANCE_TO_PLAYER_LIMIT:
		velocity = lerp(velocity, _direction * _speed, SMOOTH_FACTOR * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, STOP_SPEED * delta)


func handle_direction() -> void:
	if _sees_player:
		_direction = global_position.direction_to(_player_ref.global_position)
	else:
		_direction = Vector2.ZERO


func handle_attack() -> void:
	if _distance_to_player < 60.0 and not _is_attacking:
		_is_attacking = true
		animation_player.play("sword_attack")
		
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "sword_attack":
		_is_attacking = false
