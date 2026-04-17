class_name Asteroid
extends Projectile

@onready var health_bar: HealthBar = $HealthBar
@export var textures: Array[Texture2D] = []
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var points: int = 5

func _ready() -> void:
	super()
	sprite_2d.texture = textures.pick_random()
	_mover.direction.x = -sign(global_position.x)
	_mover.direction.y = randf_range(-0.5, 0.5)
	_mover.setup_velocity()

func activate() -> void:
	super()
	sprite_2d.texture = textures.pick_random()
	_mover.direction.x = -sign(global_position.x)
	_mover.direction.y = randf_range(-0.5, 0.5)
	_mover.setup_velocity()

func _on_hurt_box_hit(damage: int, source: Node) -> void:
	health_bar.take_damage(damage)

func _on_hit_box_area_entered(_area: Area2D) -> void:
	pass

func _on_health_bar_died() -> void:
	die()

func die() -> void:
	SignalHub.points_scored.emit(points)
	explode()
	deactivate()
