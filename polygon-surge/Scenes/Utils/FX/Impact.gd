class_name BasicFX
extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D
@export var same_dir: bool = false

var _dir: float


func activate(pos: Vector2, dir: Vector2) -> void:
	global_position = pos
	_dir = (dir).angle() if same_dir else  (-dir).angle() 

func _ready() -> void:
	particles.rotation = _dir
	particles.emitting = true


func _on_cpu_particles_2d_finished() -> void:
	queue_free()
