# camera_controller.gd
extends Camera2D

@export var aim_lead_strength: float = 80.0
@export var move_lead_strength: float = 30.0
@export var lerp_speed: float = 5.0

var _target_offset: Vector2

func update_lead(aim_direction: Vector2, move_direction: Vector2) -> void:
	_target_offset = (aim_direction * aim_lead_strength) + (move_direction * move_lead_strength)

func _process(delta: float) -> void:
	offset = offset.lerp(_target_offset, lerp_speed * delta)
