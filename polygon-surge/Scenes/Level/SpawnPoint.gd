class_name SpawnPoint
extends Node2D

@export var category: Constants.SpawnCategory = Constants.SpawnCategory.NOT_SET
@export var radius: float = 32.0


func _ready() -> void:
	if category == Constants.SpawnCategory.NOT_SET:
		push_warning("SpawnPoint '%s' has no category set." % name)

func get_spawn_position() -> Vector2:
	return global_position + Vector2.from_angle(randf() * TAU) * randf_range(0.0, radius)
