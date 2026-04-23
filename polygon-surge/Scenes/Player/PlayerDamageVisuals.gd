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
 

func on_damaged(percentage_hp: float) -> void:
	_hit_flash()
	if percentage_hp > 0.8:
		pass
	elif percentage_hp > 0.6:
		_reveal(crack_top_armor)
	elif percentage_hp > 0.4:
		_reveal(crack_top_armor2)
	elif percentage_hp > 0.2:
		_reveal(crack_outside)
	else:
		_reveal_multiple([crack_outside2, leak_top_armor, leak_top_armor2])
	


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
