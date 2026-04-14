class_name SwordEnemy
extends Enemy

const ATTACK_DISTANCE_OFFSET: float = 30.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debug_label: Label = $DebugLabel
@onready var move_component: MoveComponent = $MoveComponent

var _is_attacking: bool = false


func _ready() -> void:
	super._ready()
	animation_player.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if not _player_ref: return
	move_component.update_limit(_player_ref.global_position)
	move_component.direction_to_or_zero(_player_ref.global_position, _sees_player)
	velocity = move_component.move_in_direction_with_limit(delta, velocity)
	handle_attack()
	move_and_slide()


func handle_attack() -> void:
	if move_component.has_reached_limit(ATTACK_DISTANCE_OFFSET) and not _is_attacking:
		_is_attacking = true
		animation_player.play("sword_attack")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "sword_attack":
		_is_attacking = false
