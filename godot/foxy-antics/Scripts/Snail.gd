class_name Snail
extends EnemyBase

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _enter_tree() -> void:
	direction *= -1

func _physics_process(delta: float) -> void:
	handle_flip()
	handle_movement()
	handle_gravity(delta)
	super._physics_process(delta)


func handle_movement() -> void:
	velocity.x = direction * speed
	animated_sprite_2d.flip_h = true if velocity.x > 0 else false


func handle_flip() -> void:
	if !ray_cast_2d.is_colliding() or is_on_wall():
		direction *= -1
		ray_cast_2d.position.x *= -1
