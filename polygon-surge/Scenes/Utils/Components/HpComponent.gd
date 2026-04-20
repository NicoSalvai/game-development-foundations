class_name HPComponent
extends Node

signal died

@export var max_hp: int = 3

var _current_hp: int
var current_hp: int:
	get: return _current_hp


func _ready() -> void:
	_current_hp = max_hp


func take_damage(amount: int) -> void:
	if _current_hp <= 0:
		return
	_current_hp -= amount
	if _current_hp <= 0:
		died.emit()


func is_dead() -> bool:
	return _current_hp <= 0
