class_name Player
extends Node2D


func _ready() -> void:
	add_to_group(Constants.PLAYER_GROUP)


func _on_hurt_box_hit(damage: int, _source: Node) -> void:
	SignalHub.player_received_damage.emit(damage)


func _on_health_bar_died() -> void:
	get_tree().paused = true
