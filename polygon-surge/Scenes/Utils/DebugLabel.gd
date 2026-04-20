class_name DebugLabel
extends Label

func _ready() -> void:
	if Utils.DEBUG_LOG:
		show()
