class_name DebugSpawner
extends Node2D

@export var scene: PackedScene
@export var interval: float = 1.0
@export var max_count: int = 5
@export var start_delay: float = 0.0

@onready var timer: Timer = $Timer

var _count: int = 0


func _ready() -> void:
	timer.wait_time = interval
	timer.timeout.connect(_on_timeout)
	if start_delay > 0.0:
		await get_tree().create_timer(start_delay).timeout
	timer.start()


func _on_timeout() -> void:
	if _count >= max_count:
		return
	var instance := scene.instantiate()
	add_child(instance)
	_count += 1
