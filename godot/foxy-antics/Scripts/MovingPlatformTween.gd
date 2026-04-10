extends StaticBody2D

@export var targets: Array[Marker2D]
@export var speed: float = 150.0

var _tween: Tween
var _target_points: Array[TargetDistanceTime] = []

func _ready() -> void:
	setup_points()
	setup_tween()

func _exit_tree() -> void:
	_tween.kill()

func setup_points() -> void:
	for i in range(len(targets) - 1):
		var dist: TargetDistanceTime = TargetDistanceTime.new(
			targets[i].global_position,
			targets[i + 1].global_position,
			speed
		)
		_target_points.append(dist)
	
	var last_dist: TargetDistanceTime = TargetDistanceTime.new(
			targets[len(targets) - 1].global_position,
			targets[0].global_position,
			speed
		)
	_target_points.append(last_dist)


func setup_tween() -> void:
	_tween = create_tween()
	_tween.set_loops()
	for target_distance_time in _target_points:
		_tween.tween_property(self, "position", target_distance_time._target, target_distance_time._time)
	_tween.tween_interval(0.05)


class TargetDistanceTime:

	var _target: Vector2
	var _time: float

	func _init(start: Vector2, end: Vector2, speed: float) -> void:
		_target = end
		_time = start.distance_to(end) / speed
