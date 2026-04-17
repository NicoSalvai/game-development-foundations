class_name Shooter
extends Node2D


@export var shoot_time: float = 3.0
@export var shoot_time_variance: float = 1.0
@export var projectile: PackedScene
@export var audio: AudioStream

@onready var shooter_timer: Timer = $ShooterTimer
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound


func _ready() -> void:
	restart_timer()
	launch_sound.stream = audio


func restart_timer() -> void:
	Constants.set_timer(shooter_timer, shoot_time, shoot_time_variance)


func _on_shooter_timer_timeout() -> void:
	restart_timer()
	shoot()


func shoot() -> void:
	launch_sound.play(	)
	SignalHub.spawn_object.emit(global_position, projectile)
