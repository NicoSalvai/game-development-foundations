extends Node

signal create_object(pos: Vector2, dir: Vector2, object_type: Constants.ObjectType)
signal poolable_returned(node: Node, object_type: Constants.ObjectType)
signal enemy_died
signal game_over
signal level_cleared
