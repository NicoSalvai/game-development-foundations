class_name Poolable
extends Node2D

var is_available: bool = false

func _enter_tree() -> void:
	deactivate()


func activate() -> void:
	is_available = false
	set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	show()


func deactivate() -> void:
	if !is_available:
		is_available = true
		set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		hide()
