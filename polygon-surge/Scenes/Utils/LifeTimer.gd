class_name LifeTimer
extends Timer

@export var function_override: String = "queue_free"
@export var should_defer: bool = true

func _on_timeout() -> void:
	if should_defer:
		get_parent().call_deferred(function_override)
	else:
		get_parent().call(function_override)
