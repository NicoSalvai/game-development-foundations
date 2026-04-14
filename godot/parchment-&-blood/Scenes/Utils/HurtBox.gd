class_name HurtBox
extends Area2D

signal hit(damage: int, source: Node)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		hit.emit(area.get_damage(), area)
