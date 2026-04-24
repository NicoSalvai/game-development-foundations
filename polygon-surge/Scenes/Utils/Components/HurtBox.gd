class_name HurtBox
extends Area2D

signal hitted(damage: int, source_position: Vector2, knockback_strength: float)


func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		hitted.emit(area.get_damage(), area.global_position, area.get_knockback_strength())
