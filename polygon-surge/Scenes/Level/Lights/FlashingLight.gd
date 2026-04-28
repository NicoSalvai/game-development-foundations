class_name FlickerLight
extends PointLight2D

@export var energy_min: float = 0.2
@export var energy_max: float = 1.0
@export var interval_min: float = 0.05
@export var interval_max: float = 0.4
@export var transition_duration: float = 0.05

var _going_up: bool = true


func _ready() -> void:
	energy = energy_min
	_flicker()


func _flicker() -> void:
	while true:
		var target: float = energy_max if _going_up else energy_min
		_going_up = not _going_up
		var tween: Tween = create_tween()
		tween.tween_property(self, "energy", target, transition_duration)
		await tween.finished
		await get_tree().create_timer(randf_range(interval_min, interval_max)).timeout
