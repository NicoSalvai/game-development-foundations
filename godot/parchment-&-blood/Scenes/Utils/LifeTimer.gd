extends Timer

@export var time: float = 2.0
@export var function_override: String = "queue_free"

func _ready() -> void:
	timeout.connect(_on_timeout)
	start(time)

func _on_timeout() -> void:
	get_parent().call_deferred(function_override)
	
