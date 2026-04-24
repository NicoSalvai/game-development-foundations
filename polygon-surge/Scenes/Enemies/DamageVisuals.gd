class_name DamageVisuals
extends Node

const FLASH_COLOR    := Color(3.0, 3.0, 3.0, 1.0)
const FLASH_DURATION := 0.06

@onready var visuals: Node2D = $".."

var _configs: Array[DamageState]
var _current_state: int = 0


func _ready() -> void:
	for child in get_children():
		if child is DamageState:
			_configs.append(child)
	for config in _configs:
		for node in config.reveals:
			node.modulate.a = 0.0


func on_damaged(percentage_hp: float, source_position: Vector2) -> void:
	_hit_flash()
	var dir := source_position.direction_to(visuals.global_position)
	var advanced := false
	while _current_state < _configs.size():
		var config: DamageState = _configs[_current_state]
		if percentage_hp <= config.threshold:
			SignalHub.create_object.emit(visuals.global_position, dir, config.particles)
			for node in config.reveals:
				_reveal(node)
			_current_state += 1
			advanced = true
		else:
			break
	if not advanced:
		var particles_type := _configs[mini(_current_state, _configs.size() - 1)].particles
		SignalHub.create_object.emit(visuals.global_position, dir, particles_type)


func _hit_flash() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(visuals, "modulate", FLASH_COLOR, FLASH_DURATION)
	tween.tween_property(visuals, "modulate", Color.WHITE, FLASH_DURATION)


func _reveal(target: Node2D) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "modulate:a", 1.0, 0.08)
