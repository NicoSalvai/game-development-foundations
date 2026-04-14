class_name EnemyDeath
extends Node2D

@onready var blood_particles: CPUParticles2D = $BloodParticles

func _ready() -> void:
	blood_particles.emitting = true
