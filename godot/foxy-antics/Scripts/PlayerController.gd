extends Node

@export var jump_control: String = "jump"
@export var left_control: String = "left"
@export var right_control: String = "right"
@export var shoot_control: String = "shoot"

var _direction: float = 0.0
var _jump: bool = false
var jump: bool:
	get: return _jump
var direction: float:
	get: return _direction
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	_direction = Input.get_axis(left_control, right_control)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(jump_control):
		_jump = true
	if event.is_action_pressed(shoot_control):
		get_parent().shoot()

func jumped() -> void:
	_jump = false
