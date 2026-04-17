extends Explosion

@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2

func activate() -> void:
	super()
	cpu_particles_2d_2.restart()
