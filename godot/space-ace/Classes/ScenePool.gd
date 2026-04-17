
class_name ScenePool


extends RefCounted


const DEBUG_POOL: bool = false


var number_active: int:
	get:
		var active: int = 0
		for item in _items:
			if item.is_available: active += 1
		return active


var _items: Array[Poolable] = []
var _packedScene: PackedScene
var _container: Node


func log_message(message: String) -> void:
	if DEBUG_POOL:
		print("[ScenePool:%s] %s" % [_packedScene.resource_path, message])


func validate_scene() -> void:
	var test = _packedScene.instantiate()
	var is_valid = test is Poolable
	test.free()
	assert(is_valid, "PackedScene root must extend Poolable: %s" % _packedScene.resource_path)


func _init(initial_count: int, scene: PackedScene, container: Node) -> void:
	_container = container
	_packedScene = scene
	
	validate_scene()
	
	log_message("Creating pool with %d items" % initial_count)
	
	for c in range(initial_count):
		add_new_item()


func add_new_item() -> Poolable:
	var ni: Poolable = _packedScene.instantiate()
	_container.add_child(ni)
	_items.append(ni)
	log_message("add_new_item() -> New Instance: {%s} :: {%d} total" % [
		ni.name, _items.size()
	])
	return ni


func activate_next(new_position: Vector2) -> void:
	log_message("activate_next() Available: {%d}/{%d} new_position{%v}" % [
		number_active, _items.size(), new_position
	])
	for item in _items:
		if item.is_available:
			log_message("activate_next() Reusing instance: {%s}" % [item.name])
			item.global_position = new_position
			item.activate()
			return
	log_message("activate_next() needs new item")
	var nitem: Poolable = add_new_item()
	nitem.global_position = new_position
	nitem.activate()
