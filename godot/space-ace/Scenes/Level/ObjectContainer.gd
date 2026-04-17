class_name ObjectContainer
extends Node

var _pools: Dictionary[PackedScene, ScenePool] = {}

func _ready() -> void:
	SignalHub.spawn_object.connect(_on_spawn_deferred)

func spawn_deferred(position: Vector2, scene: PackedScene) -> void:
	if !_pools.has(scene):
		var new_pool: ScenePool = ScenePool.new(5, scene, self)
		_pools[scene] = new_pool
	_pools[scene].activate_next(position)

func _on_spawn_deferred(position: Vector2, scene: PackedScene) -> void:
	call_deferred("spawn_deferred", position, scene)
