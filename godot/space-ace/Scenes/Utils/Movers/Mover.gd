class_name Mover
extends Node

@export var speed: float = 0.0
@export var rotation_speed_deg: float = 0.0
@export var direction: Vector2 = Vector2.ZERO

var _parent: Node2D
var _velocity: Vector2

func _ready() -> void:
	_parent = get_parent() as Node2D
	assert(_parent, "Mover must be child of Node2")
	setup_velocity()


func _physics_process(delta: float) -> void:
	_parent.position += _velocity * delta
	_parent.rotation_degrees += rotation_speed_deg * delta


func setup_velocity() -> void:
	_velocity = speed * direction
