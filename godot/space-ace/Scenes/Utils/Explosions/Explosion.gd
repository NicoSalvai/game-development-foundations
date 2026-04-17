class_name Explosion
extends Poolable

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var sounds: AudioStreamPlayer2D = $Sounds

func _ready() -> void:
	sounds.finished.connect(deactivate)

func activate() -> void:
	super()
	cpu_particles_2d.restart()
	sounds.play()
