class_name Checkpoint
extends Area2D

var _boss_killed: bool = false

func _ready() -> void:
	SignalHub.on_boss_killed.connect(_on_boss_killed)

func _on_boss_killed() -> void:
	_boss_killed = true


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Open":
		set_deferred("monitoring", true)


func _on_area_entered(_area: Area2D) -> void:
	SignalHub.emit_on_level_completed()
