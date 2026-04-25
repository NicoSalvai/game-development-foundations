class_name Door
extends StaticBody2D

@export var fade_duration: float = 0.3

@onready var polygon: Polygon2D = $Polygon2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var light_occluder_2d: LightOccluder2D = $LightOccluder2D

signal player_crossed

func open() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(polygon, "modulate:a", 0.0, fade_duration)
	await tween.finished
	collision_shape_2d.set_deferred("disabled", true)
	light_occluder_2d.hide()


func close() -> void:
	collision_shape_2d.set_deferred("disabled", false)
	light_occluder_2d.show()
	var tween: Tween = create_tween()
	tween.tween_property(polygon, "modulate:a", 1.0, fade_duration)


func _on_area_2d_area_entered(_area: Area2D) -> void:
	close()
	player_crossed.emit()
