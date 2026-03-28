class_name Hobbit


extends Node2D

signal hit_wizard

var rotation_speed: int = randi() % 3 + 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(rotation_speed * delta)
	pass

func hit_by_spell() -> void:
	apply_scale(Vector2.ONE * 0.5)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		hit_wizard.emit()
