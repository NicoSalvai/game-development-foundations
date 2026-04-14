class_name ArcherEnemy
extends Enemy


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Shooter = $Shooter
@onready var debug_label: Label = $DebugLabel
@onready var move_component: MoveComponent = $MoveComponent


var _is_aiming: bool = false
var _finished_aiming: bool = false
var _orthogonal_speed_factor: float = 0.0

func _ready() -> void:
	super._ready()
	animation_player.animation_finished.connect(_on_animation_finished)
	_orthogonal_speed_factor = randf_range(-1.0, 1.0)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if not _player_ref: return
	move_component.update_limit(_player_ref.global_position)
	move_component.direction_to_or_zero(_player_ref.global_position, _sees_player)
	move_component.orthogonal_strafe(_orthogonal_speed_factor)
	velocity = move_component.move_in_direction_with_limit(delta, velocity)
	handle_shoot()
	handle_aiming()
	move_and_slide()


func handle_shoot() -> void:
	if _finished_aiming and _is_aiming:
		shoot()


func shoot() -> void:
	shooter.shoot(_player_ref.global_position)
	animation_player.play("Archer/re_aim")
	_finished_aiming = false


func handle_aiming() -> void:
	if _sees_player and !_is_aiming and move_component.has_reached_limit():
		animation_player.play("Archer/aim")
		_is_aiming = true
	elif !_sees_player and _is_aiming:
		_is_aiming = false
		_finished_aiming = false
		animation_player.play("Archer/RESET")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name in ["Archer/aim", "Archer/re_aim"]:
		_finished_aiming = true
