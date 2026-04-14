extends Node

signal on_request_arrow(pos: Vector2, direction: Vector2, speed: float, type: Constants.ArrowType)
signal on_release_arrow(arrow: Arrow, type: Constants.ArrowType)
signal on_enemy_died
