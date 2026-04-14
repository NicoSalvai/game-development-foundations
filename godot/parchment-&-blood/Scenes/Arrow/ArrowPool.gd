class_name ArrowPool
extends Node

const ARROWS: Dictionary[Constants.ArrowType, PackedScene] = {
	Constants.ArrowType.PLAYER_ARROW:preload("uid://ckunlqami0n7s"),
	Constants.ArrowType.ENEMY_ARROW: preload("uid://cwqlfnag843qx")
}

var _available: Dictionary[Constants.ArrowType, Array] = {
	Constants.ArrowType.PLAYER_ARROW: [],
	Constants.ArrowType.ENEMY_ARROW: []
}


func _ready() -> void:
	SignalHub.on_request_arrow.connect(_on_request_arrow)
	SignalHub.on_release_arrow.connect(_on_release_arrow)


func _on_release_arrow(arrow: Arrow, type: Constants.ArrowType) -> void:
	arrow.hide()
	arrow.process_mode = Node.PROCESS_MODE_DISABLED
	_available[type].append(arrow)


func _on_request_arrow(pos: Vector2, direction: Vector2, speed: float, type: Constants.ArrowType) -> void:
	var arrow: Arrow
	if _available[type].is_empty():
		arrow = ARROWS[type].instantiate()
		add_child(arrow)
	else:
		arrow =_available[type].pop_back()
	arrow.show()
	arrow.setup(pos, direction, speed)
	arrow.process_mode = Node.PROCESS_MODE_INHERIT
