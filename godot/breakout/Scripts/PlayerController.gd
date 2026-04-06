class_name PlayerController


extends Node


@export var left_control: String = "ui_left"
@export var right_control: String = "ui_right"
@export var launch_control: String = "ui_accept"


var direction: float = 0.0
var launch_ball: bool = false


func _process(_delta: float) -> void:
	direction = Input.get_axis(left_control, right_control)
	if Input.is_action_just_pressed(launch_control): 
		launch_ball = true
