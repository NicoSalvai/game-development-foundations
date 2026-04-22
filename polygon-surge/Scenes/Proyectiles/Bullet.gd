class_name Bullet
extends Node2D

@export var speed: float = 500.0
@export var object_type: Constants.ObjectType = Constants.ObjectType.NONE

@onready var life_timer: Timer = $LifeTimer

var _direction: Vector2 = Vector2.ZERO
var _active: bool = false

func activate(pos: Vector2, direction: Vector2) -> void:
	global_position = pos
	_direction = direction
	rotation = direction.angle()
	life_timer.start()
	_active = true
	set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	show()


func deactivate() -> void:
	if _active:
		_active = false
		SignalHub.poolable_returned.emit(self, object_type)
		set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		hide()


func _physics_process(delta: float) -> void:
	global_position += _direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	deactivate()


func _on_hit_box_hitted(node: Node2D, is_area: bool) -> void:
	SignalHub.create_object.emit(global_position, _direction, Constants.ObjectType.BULLET_IMPACT)
	deactivate()
