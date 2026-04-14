class_name Shooter
extends Node2D

@export var speed: float = 900.0
@export var type: Constants.ArrowType

var can_shoot: bool = true


func shoot(shoot_to: Vector2) -> void:
	var dir: Vector2 = global_position.direction_to(shoot_to)
	SignalHub.on_request_arrow.emit(global_position, dir, speed, type)
