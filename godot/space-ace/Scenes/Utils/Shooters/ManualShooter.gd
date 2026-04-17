class_name ManualShooter
extends Node2D


@export var input_shoot: String = "shoot"
@export var shoot_time: float = 0.5
@export var projectile: PackedScene
var _can_shoot: bool = true

@onready var shooter_timer: Timer = $ShooterTimer
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and _can_shoot:
		shoot()


func restart_timer() -> void:
	Constants.set_timer(shooter_timer, shoot_time)


func _on_shooter_timer_timeout() -> void:
	_can_shoot = true


func shoot() -> void:
	_can_shoot = false
	launch_sound.play()
	SignalHub.spawn_object.emit(global_position, projectile)
	restart_timer()
