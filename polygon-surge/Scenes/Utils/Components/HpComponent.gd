class_name HPComponent
extends Node

signal died

@export var max_hp: int = 10
@export var apply_modifiers: bool = false

var _current_hp: int
var current_hp: int:
	get: return _current_hp
var percentage_hp: float:
	get: return float(current_hp) / float(max_hp)


func _ready() -> void:
	if apply_modifiers:
		max_hp = roundi(max_hp * TechTreeState.get_modifier(TechTreeState.Stat.MAX_HP))
	_current_hp = max_hp


func take_damage(amount: int) -> void:
	if _current_hp <= 0:
		return
	_current_hp -= amount
	if _current_hp <= 0:
		died.emit()


func is_dead() -> bool:
	return _current_hp <= 0
