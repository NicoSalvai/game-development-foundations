extends Camera2D

const SHAKE_MAX_OFFSET := 8.0

@export var aim_lead_strength: float = 80.0
@export var move_lead_strength: float = 30.0
@export var lerp_speed: float = 5.0

var _target_offset: Vector2
var _trauma: float = 0.0


func update_lead(aim_direction: Vector2, move_direction: Vector2) -> void:
	_target_offset = (aim_direction * aim_lead_strength) + (move_direction * move_lead_strength)


func add_trauma(amount: float) -> void:
	_trauma = minf(_trauma + amount, 1.0)


func _process(delta: float) -> void:
	_update_shake(delta)
	var lead_offset := offset.lerp(_target_offset, lerp_speed * delta)
	offset = lead_offset + _shake_offset()


func _update_shake(delta: float) -> void:
	_trauma = maxf(_trauma - delta, 0.0)


func _shake_offset() -> Vector2:
	var shake := _trauma * _trauma
	return Vector2(
		randf_range(-1.0, 1.0) * SHAKE_MAX_OFFSET * shake,
		randf_range(-1.0, 1.0) * SHAKE_MAX_OFFSET * shake
	)
