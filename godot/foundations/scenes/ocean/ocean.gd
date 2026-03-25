extends Node2D

@onready var plane: Sprite2D = $Plane
@onready var helicopter: Sprite2D = $Helicopter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	plane.move_local_x(delta * 100.0)
	helicopter.move_local_x(delta * 50.0)
	helicopter.rotate(delta * -0.5)
	
	if Input.is_action_pressed("ui_left"):
		plane.rotate(delta * -1.5)
	if Input.is_action_pressed("ui_right"):
		plane.rotate(delta * 1.5)
