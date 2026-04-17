class_name EnemyBase
extends PathFollow2D

const ENEMY_SHIP_EXPLOSION = preload("uid://dqim4gcis8bm6")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health_bar: HealthBar = $HealthBar
@export var speed: float = 0.0
@export var points: int = 0
@export var power_up_chance = 1.0
@export var power_up_scene: PackedScene = preload("uid://bgbfe7yrnido0")
@export var missile_chance = 1.0
@export var missile_scene: PackedScene = preload("uid://cdbd67lexliys")

func _physics_process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio >= 0.99:
		queue_free()


func _on_hurt_box_hit(damage: int, _source: Node) -> void:
	health_bar.take_damage(damage)


func _on_health_bar_died() -> void:
	SignalHub.spawn_object.emit(global_position, ENEMY_SHIP_EXPLOSION)
	SignalHub.points_scored.emit(points)
	if power_up_scene and randf() < power_up_chance:
		SignalHub.spawn_object.emit(global_position, power_up_scene)
	if missile_scene and randf() < missile_chance:
		SignalHub.spawn_object.emit(global_position, missile_scene)
	var tween: Tween = create_tween()
	tween.tween_property(sprite_2d, "modulate", Color("#ff0000bb"), 0.25)
	tween.tween_callback(queue_free)
