class_name PlayerDamageVisuals
extends Node

const FLASH_COLOR    := Color(3.0, 3.0, 3.0, 1.0)
const FLASH_DURATION := 0.06

@onready var visuals: Node2D              = $".."
@onready var crack_top_armor: Polygon2D   = $"../TopArmor/Crack"
@onready var leak_top_armor: Polygon2D    = $"../TopArmor/Leak"
@onready var crack_top_armor2: Polygon2D  = $"../TopArmor2/Crack"
@onready var leak_top_armor2: Polygon2D   = $"../TopArmor2/Leak"
@onready var crack_outside: Polygon2D     = $"../Outside/Crack"
@onready var crack_outside2: Polygon2D    = $"../Outside2/Crack"


func _ready() -> void:
	crack_top_armor.modulate.a  = 0.0
	leak_top_armor.modulate.a   = 0.0
	crack_top_armor2.modulate.a = 0.0
	leak_top_armor2.modulate.a  = 0.0
	crack_outside.modulate.a    = 0.0
	crack_outside2.modulate.a   = 0.0


func on_damaged(current_hp: int) -> void:
	_hit_flash()
	match current_hp:
		4: _reveal(crack_top_armor)
		3: _reveal(crack_top_armor2)
		2: _reveal(crack_outside)
		1: _reveal_multiple([crack_outside2, leak_top_armor, leak_top_armor2])


func _hit_flash() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(visuals, "modulate", FLASH_COLOR, FLASH_DURATION)
	tween.tween_property(visuals, "modulate", Color.WHITE, FLASH_DURATION)


func _reveal_multiple(targets: Array[Polygon2D]) -> void:
	for target in targets:
		_reveal(target)


func _reveal(target: Polygon2D) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "modulate:a", 1.0, 0.08)
