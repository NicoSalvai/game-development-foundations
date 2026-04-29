class_name DashComponent
extends Node

@onready var timer: Timer = $Timer
@onready var cooldown_timer: Timer = $CooldownTimer

@export var dash_duration: float = 0.1
@export var dash_cooldown: float = 2.0
@export var dash_speed: float = 1000.0
@export var apply_modifiers: bool = false

var is_dashing: bool = false
var can_dash: bool = true

var _body: CharacterBody2D


func _ready() -> void:
	_body = get_parent() as CharacterBody2D
	if apply_modifiers:
		dash_cooldown = dash_cooldown * TechTreeState.get_modifier(TechTreeState.Stat.DASH_COOLDOWN)
	timer.wait_time = dash_duration
	timer.one_shot = true
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.one_shot = true


func try_dash(direction: Vector2) -> bool:
	if not can_dash or direction == Vector2.ZERO:
		return false
	is_dashing = true
	can_dash = false
	_body.velocity = direction * dash_speed
	timer.start()
	return true


func _on_cooldown_timer_timeout() -> void:
	can_dash = true


func _on_timer_timeout() -> void:
	is_dashing = false
	cooldown_timer.start()


func get_cooldown_time() -> float:
	return cooldown_timer.time_left
