class_name EnemyDeathParticles
extends Node2D

@onready var core_partciles: CPUParticles2D = $CorePartciles
@onready var armor_particles: CPUParticles2D = $ArmorParticles
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _finished_count: int = 0


func activate(pos: Vector2, _dir: Vector2) -> void:
	global_position = pos


func _ready() -> void:
	armor_particles.emitting = true
	core_partciles.emitting  = true
	audio_stream_player_2d.play()



func _on_particles_finished() -> void:
	_finished_count += 1
	if _finished_count >= 2:
		queue_free()
