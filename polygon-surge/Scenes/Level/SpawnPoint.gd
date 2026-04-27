class_name SpawnPoint
extends Node2D

@export var category: Constants.SpawnCategory = Constants.SpawnCategory.NOT_SET
@export var radius: float = 32.0

@onready var indicator: Sprite2D = $Sprite2D

var _tween: Tween


func _ready() -> void:
	if category == Constants.SpawnCategory.NOT_SET:
		push_warning("SpawnPoint '%s' has no category set." % name)
	indicator.visible = false


func get_spawn_position() -> Vector2:
	return global_position + Vector2.from_angle(randf() * TAU) * randf_range(0.0, radius)


func activate() -> void:
	indicator.visible = true
	indicator.modulate.a = 1.0
	if _tween:
		_tween.kill()
	_tween = create_tween().set_loops()
	_tween.tween_property(indicator, "modulate:a", 0.2, 0.5)
	_tween.tween_property(indicator, "modulate:a", 1.0, 0.5)


func deactivate() -> void:
	if _tween:
		_tween.kill()
		_tween = null
	indicator.visible = false
