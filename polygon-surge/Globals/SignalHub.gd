extends Node

signal create_object(pos: Vector2, dir: Vector2, object_type: Constants.ObjectType)
signal poolable_returned(node: Node, object_type: Constants.ObjectType)
