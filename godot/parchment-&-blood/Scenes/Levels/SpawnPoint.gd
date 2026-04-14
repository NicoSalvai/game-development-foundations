class_name SpawnPoint
extends Marker2D

@export var direction: Constants.WaveDirections

func get_spawn_position() -> Vector2:
	var offset: Vector2 = Vector2.from_angle(randf() * TAU) * randf_range(0.0, 30.0)
	return global_position + offset
