extends CharacterBody2D

class_name Tappy

const JUMP_FORCE: float = -350.0
const THRUST_ANIMATION: String = "thrust"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _gravity: float = ProjectSettings.get("physics/2d/default_gravity")
var _jumped: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event is InputEventScreenTouch:
		_jumped = true
		animation_player.play("RESET")


func _physics_process(delta: float) -> void:
	fly(delta)
	move_and_slide()
	if is_on_floor():
		die()


func fly(delta: float) -> void:
	velocity.y += delta * _gravity
	if _jumped:
		animation_player.play(THRUST_ANIMATION)
		velocity.y = JUMP_FORCE
		_jumped = false


func die() -> void:
	SignalBus.emit_tappy_plane_died()
	get_tree().paused = true
