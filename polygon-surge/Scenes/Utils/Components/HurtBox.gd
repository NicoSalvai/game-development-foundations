class_name HurtBox
extends Area2D

signal hitted(damage: int)


func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		hitted.emit(area.get_damage())
