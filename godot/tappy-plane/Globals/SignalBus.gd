extends Node

class_name SignalHub

signal tappy_plane_died
signal point_scored


func emit_tappy_plane_died() -> void:
	tappy_plane_died.emit()


func emit_point_scored() -> void:
	point_scored.emit()
