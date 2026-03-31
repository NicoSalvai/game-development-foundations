extends Node


class_name SignalBusO


signal point_scored(player_id: int)


func emit_point_scored(player_id: int) -> void:
	point_scored.emit(player_id)
