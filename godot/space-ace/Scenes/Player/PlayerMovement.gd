class_name PlayerMovement
extends Node

@export var left: String = "left"
@export var right: String = "right"
@export var up: String = "up"
@export var down: String = "down"
@export var speed: float = 300.0
@export var margin: float = 64.0

var direction: Vector2 = Vector2.ZERO

var _parent: Node2D
var _movement_rect: Rect2


func _ready() -> void:
	_parent = get_parent() as Node2D
	if !_parent:
		printerr("PlayerMovement not attached to Node2D")
		queue_free()
	else:
		_movement_rect = _parent.get_viewport_rect().grow(-margin)

func _physics_process(delta: float) -> void:
	direction = Input.get_vector(left, right, up, down)
	_parent.position += direction * speed * delta
	_parent.position = _parent.position.clamp(_movement_rect.position, _movement_rect.end)
	
