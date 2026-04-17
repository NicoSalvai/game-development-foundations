class_name Projectile
extends Poolable

@export var explosion_scene: PackedScene
@onready var life_timer: Timer = $LifeTimer

var _mover: Mover

func _ready() -> void:
	for c in get_children():
		if c is Mover:
			_mover = c
			break
	assert(_mover, "No mover on base projectile")


func activate() -> void:
	super()
	life_timer.start()
	_mover.setup_velocity()


func _on_life_timer_timeout() -> void:
	deactivate()


func _on_screen_notifier_screen_exited() -> void:
	deactivate()


func _on_hit_box_area_entered(_area: Area2D) -> void:
	explode()
	deactivate()

func explode() -> void:
	if !explosion_scene: 
		return
	SignalHub.spawn_object.emit(global_position, explosion_scene)
