class_name Pilar
extends StaticBody2D

@export var scaling: float = 1.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var light_occluder_2d: LightOccluder2D = $LightOccluder2D

func _ready() -> void:
	collision_shape_2d.shape.radius *= scaling
	var polygon : PackedVector2Array = polygon_2d.polygon
	for i in polygon.size():
		polygon.set(i, polygon[i] * scaling)
	polygon_2d.polygon = polygon
	light_occluder_2d.occluder.polygon = polygon
