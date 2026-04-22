class_name HurtBox
extends Area2D

# HurtBox.gd
signal hitted(damage: int, source_position: Vector2)

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		hitted.emit(area.get_damage(), area.global_position)
