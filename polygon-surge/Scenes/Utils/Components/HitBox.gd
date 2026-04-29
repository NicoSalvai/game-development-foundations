class_name HitBox
extends Area2D

@export var damage: int = 10
@export var knockback_strength: float = 400.0
@export var apply_modifiers: bool = false
@export var stat: TechTreeState.Stat = TechTreeState.Stat.NONE

signal hitted(node: Node2D, is_area: bool)


func _ready() -> void:
	if apply_modifiers and stat != TechTreeState.Stat.NONE:
		damage = roundi(damage * TechTreeState.get_modifier(stat))


func get_damage() -> int:
	return damage


func get_knockback_strength() -> float:
	return knockback_strength


func _on_area_entered(area: Area2D) -> void:
	hitted.emit(area, true)


func _on_body_entered(body: Node2D) -> void:
	hitted.emit(body, false)
