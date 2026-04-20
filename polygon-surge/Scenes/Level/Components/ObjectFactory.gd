class_name ObjectFactory
extends Node

const PACKED_SCENES_DICT: Dictionary[Constants.ObjectType, PackedScene] = {
	Constants.ObjectType.PLAYER_BULLET: preload("uid://d0au5nli0obss")
}


func create_and_add(object_type: Constants.ObjectType, pos: Vector2, dir: Vector2) -> void:
	var instance: Node = create_object(object_type)
	if instance:
		instance.activate(pos, dir)
		add_child(instance)


func create_object(object_type: Constants.ObjectType) -> Node:
	if not PACKED_SCENES_DICT.has(object_type):
		printerr("Attempting to create a Scene of type (%s) without a PackedScene in ObjectFactory" % object_type)
		return null
	return PACKED_SCENES_DICT[object_type].instantiate()
