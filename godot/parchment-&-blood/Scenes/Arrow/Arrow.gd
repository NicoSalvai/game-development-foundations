class_name Arrow
extends Node2D

@onready var life_timer: Timer = $LifeTimer
@onready var hit_box: HitBox = $HitBox
@onready var visible_on_screen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var type: Constants.ArrowType

var _direction: Vector2 = Vector2.ZERO
var _speed: float = 0.0
var _released: bool = false

func _ready() -> void:
	hit_box.area_entered.connect(_on_hit_box_area_entered, CONNECT_DEFERRED)
	hit_box.body_entered.connect(_on_hit_box_body_entered, CONNECT_DEFERRED)
	visible_on_screen.screen_exited.connect(_on_screen_exited, CONNECT_DEFERRED)
	

func setup(pos: Vector2, direction: Vector2, speed: float):
	assert(type != null, "Arrow type must be set in the inherited scene")
	global_position = pos
	_direction = direction
	_speed = speed
	rotation = _direction.angle()
	_released = false


func release() -> void:
	if _released:
		return
	_released = true
	life_timer.stop()
	SignalHub.on_release_arrow.emit(self, type)


func _physics_process(delta: float) -> void:
	global_position += delta * _direction * _speed
	

func _on_screen_exited() -> void:
	release()


func _on_hit_box_area_entered(area: Area2D) -> void:
	release()


func _on_hit_box_body_entered(body: Node2D) -> void:
	release()
