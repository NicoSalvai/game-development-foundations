class_name ChargedShooterComponent
extends ShooterComponent

@export var charge_time_min: float = 1.0
@export var charge_time_max: float = 1.5

var _charge_time: float = 0.0
var _charging_input: bool = false

signal fired

func _physics_process(delta: float) -> void:
	if _charging_input and _can_shoot:
		_charge_time = minf(_charge_time + delta, charge_time_max)
	elif not _charging_input and _charge_time > 0.0:
		if _charge_time >= charge_time_min:
			_fire()
		_charge_time = 0.0


func shoot(pressed: bool) -> bool:
	_charging_input = pressed
	return false
	

func get_charge_ratio() -> float:
	return _charge_time / charge_time_max


func _fire() -> void:
	super()
	fired.emit()
