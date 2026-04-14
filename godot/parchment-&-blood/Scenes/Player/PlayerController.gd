class_name PlayerController
extends Node

@export var up_control: String = "up"
@export var down_control: String = "down"
@export var left_control: String = "left"
@export var right_control: String = "right"
@export var aim_control: String = "aim"
@export var shoot_control: String = "shoot"

var direction: Vector2 = Vector2.ZERO
var aiming: bool = false
var shoot: bool = false

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector(left_control, right_control, up_control, down_control)
	aiming = Input.is_action_pressed(aim_control)
	shoot = Input.is_action_pressed(shoot_control)
