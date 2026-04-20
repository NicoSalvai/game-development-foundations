class_name ShooterComponent
extends Node2D


@export var fire_rate: float = 0.25
@export var object_type: Constants.ObjectType = Constants.ObjectType.NONE

var _can_shoot: bool = true

@onready var fire_timer: Timer = $FireTimer


func _ready() -> void:
	assert(object_type != Constants.ObjectType.NONE,
		"ShooterComponent '%s' has no object_type set" % name)
	fire_timer.wait_time = fire_rate


func shoot(pressed: bool) -> void:
	if pressed and _can_shoot:
		_fire()


func _fire() -> void:
	_can_shoot = false
	SignalHub.create_object.emit(global_position, global_transform.x, object_type)
	fire_timer.start()


func _on_fire_timer_timeout() -> void:
	_can_shoot = true
