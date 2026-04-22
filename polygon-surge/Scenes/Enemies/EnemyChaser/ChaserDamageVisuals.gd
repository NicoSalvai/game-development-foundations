class_name ChaserDamageVisuals
extends Node

const FLASH_COLOR := Color(3.0, 3.0, 3.0, 1.0)
const FLASH_DURATION := 0.06

@onready var visuals: Node2D = $".."
@onready var armor: Polygon2D = $"../Armor"
@onready var armor2: Polygon2D = $"../Armor2"
@onready var armor3: Polygon2D = $"../Armor3"
@onready var weapon2: Polygon2D = $"../Weapon2"
@onready var weapon3: Polygon2D = $"../Weapon3"

var _origins: Dictionary = {}


func _ready() -> void:
	_origins = {
		armor:   armor.position,
		armor2:  armor2.position,
		armor3:  armor3.position,
		weapon2: weapon2.position,
		weapon3: weapon3.position,
	}


func on_damaged(current_hp: int, source_position: Vector2) -> void:
	_hit_flash()
	match current_hp:
		2: _state_cracked(source_position)
		1: _state_exposed(source_position)


func _emit_hit_particles(type: Constants.ObjectType, source_position: Vector2) -> void:
	var dir := source_position.direction_to(visuals.global_position)
	SignalHub.create_object.emit(visuals.global_position, dir, type)


func _hit_flash() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(visuals, "modulate", FLASH_COLOR, FLASH_DURATION)
	tween.tween_property(visuals, "modulate", Color.WHITE, FLASH_DURATION)


func _state_cracked(source_position: Vector2) -> void:
	_emit_hit_particles(Constants.ObjectType.ENEMY_HIT_ARMOR, source_position)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(armor,   "position", _origins[armor]   + Vector2(-0.5, -1),  0.15)
	tween.tween_property(armor2,  "position", _origins[armor2]  + Vector2(-0.5,  1),  0.15)
	tween.tween_property(weapon2, "rotation_degrees", -2,  0.15)
	tween.tween_property(weapon3, "rotation_degrees", 2,  0.15)


func _state_exposed(source_position: Vector2) -> void:
	_emit_hit_particles(Constants.ObjectType.ENEMY_HIT_CORE, source_position)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(armor,   "position", _origins[armor]   + Vector2(-1, -1.5),  0.15)
	tween.tween_property(armor2,  "position", _origins[armor2]  + Vector2(-1,  1.5),  0.15)
	tween.tween_property(armor,   "rotation_degrees", -1.5,  0.15)
	tween.tween_property(armor2,  "rotation_degrees", 1.5,  0.15)
	tween.tween_property(armor3,  "position", _origins[armor3]  + Vector2(-1,   0), 0.2)
	tween.tween_property(armor3,  "rotation_degrees", 2,  0.2)
	tween.tween_property(weapon2, "position", _origins[weapon2] + Vector2(-1,  0), 0.2)
	tween.tween_property(weapon3, "position", _origins[weapon3] + Vector2(-1,  0), 0.2)
