extends Area2D


class_name Dice


signal hitted_bottom


const SPEED_FALL: float = 180.0
const SPEED_ROTATION: float = 5.0


@onready var dice: Sprite2D = $Dice
var direction: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = 1.0 if randf() < 0.5 else -1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	movement(delta)
	check_hitted_bottom()


func movement(delta: float) -> void:
	dice.rotate(direction * SPEED_ROTATION * delta)
	move_local_y(delta * SPEED_FALL)


func check_hitted_bottom() -> void:
	if get_viewport_rect().end.y < position.y:
		hitted_bottom.emit()
		queue_free()

	
