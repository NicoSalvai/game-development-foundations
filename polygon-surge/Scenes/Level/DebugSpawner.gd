class_name DebugSpawner
extends Node2D

@export var chaser_scene: PackedScene
@export var interval: float = 1.0
@export var max_count: int = 5

@onready var timer: Timer = $Timer

var _count: int = 0

func _ready() -> void:
	timer.wait_time = interval
	timer.timeout.connect(_on_timeout)
	timer.start()

func _on_timeout() -> void:
	if _count >= max_count:
		return
	var chaser = chaser_scene.instantiate()
	add_child(chaser)
	_count += 1
