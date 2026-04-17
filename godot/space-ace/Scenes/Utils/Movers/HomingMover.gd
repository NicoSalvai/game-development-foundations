class_name HomingMover
extends TargetedMover


func _physics_process(delta: float) -> void:
	var angle2: float = _parent.get_angle_to(_target.global_position)
	var step = min(
		abs(angle2), 
		deg_to_rad(rotation_speed_deg) * delta
	)
	_parent.rotate(step * sign(angle2))
	_parent.position += _parent.transform.x * speed * delta
