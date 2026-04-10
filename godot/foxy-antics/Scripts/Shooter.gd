class_name Shooter
extends Node2D


@onready var shoot_timer: Timer = $ShootTimer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var speed: float = 50.0
@export var bullet_key: Constants.ObjectType
@export var shoot_cooldown: float = 0.7

var _can_shoot: bool = true

func _ready() -> void:
	shoot_timer.start(shoot_cooldown)

func shoot(direction: Vector2) -> void:
	if _can_shoot:
		audio_stream_player_2d.play()
		start_timer()
		SignalHub.emit_on_create_bullet(global_position, direction, speed, bullet_key)

func start_timer() -> void:
	shoot_timer.start(shoot_cooldown)
	_can_shoot = false

func _on_shoot_timer_timeout() -> void:
	_can_shoot = true
