class_name Pool
extends Node


@export var object_type: Constants.ObjectType = Constants.ObjectType.NONE
@export var initial_pool_size: int = 0

var _free_objects: Array[Node] = []

@onready var factory: ObjectFactory = get_parent().get_node("ObjectFactory")


func _ready() -> void:
	validate_pool_settings()
	for i in initial_pool_size:
		var node := factory.create_object(object_type)
		node.deactivate()
		_free_objects.append(node)
		add_child(node)


func validate_pool_settings() -> void:
	assert(object_type != Constants.ObjectType.NONE, "Pool %s should have a setter ObjectType" % name)
	var test_node = factory.create_object(object_type)
	var is_valid = test_node.has_method("activate") && test_node.has_method("deactivate")
	test_node.free()
	assert(is_valid, "ObjectType for Pool %s is missing poolable methods" % object_type)


func request(pos: Vector2, dir: Vector2) -> void:
	var node: Node
	if _free_objects.is_empty():
		node = factory.create_object(object_type)
		add_child(node)
	else:
		node = _free_objects.pop_back()

	node.activate(pos, dir)


func object_returned(node: Node) -> void:
	_free_objects.append(node)
