class_name SpreadShooterComponent
extends ShooterComponent

@export var pellet_count: int = 6
@export var spread_angle: float = 30.0


func _ready() -> void:
	super()
	if apply_modifiers:
		pellet_count = roundi(pellet_count * TechTreeState.get_modifier(TechTreeState.Stat.SHOTGUN_PELLETS))


func _fire() -> void:
	_can_shoot = false
	var angle_step := spread_angle / (pellet_count - 1)
	var start_angle := global_transform.x.angle() - deg_to_rad(spread_angle / 2.0)
	for i in pellet_count:
		var direction := Vector2.from_angle(start_angle + deg_to_rad(angle_step * i))
		SignalHub.create_object.emit(global_position, direction, object_type)
	fire_timer.start()
