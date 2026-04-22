class_name DashVisuals
extends Node2D

@export var separation_strength: float = 12.0
@export var return_duration: float = 0.15

const PIECES: Array[Dictionary] = [
	{ "path": "CoreStruct", "factor":  0.3, "delay": 0.00 },
	{ "path": "TopArmor",   "factor":  0.4, "delay": 0.02 },
	{ "path": "TopArmor2",  "factor":  0.4, "delay": 0.02 },
	{ "path": "Outside",    "factor":  0.5, "delay": 0.04 },
	{ "path": "Outside2",   "factor":  0.5, "delay": 0.04 },
	{ "path": "ArmorBack",  "factor":  0.6, "delay": 0.06 },
	{ "path": "ArmorBack2", "factor":  0.6, "delay": 0.06 },
]

@onready var _visuals: Node2D = get_parent()


func play_dash(dash_direction: Vector2) -> void:
	SignalHub.create_object.emit(_visuals.global_position, dash_direction, Constants.ObjectType.DASH_PARTICLES)
	var local_direction := _visuals.to_local(_visuals.global_position + dash_direction) .normalized()
	
	for piece_data in PIECES:
		var piece: Node2D = _visuals.get_node(piece_data["path"])
		var target_offset: Vector2 = local_direction * piece_data["factor"] * separation_strength

		var tween := create_tween()
		tween.tween_interval(piece_data["delay"])
		tween.tween_property(piece, "position", target_offset, 0.05)\
			.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property(piece, "position", Vector2.ZERO, return_duration)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
