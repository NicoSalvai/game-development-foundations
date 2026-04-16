class_name TileLayers

var _floor: Array[Vector2i]
var _wall: Array[Vector2i]
var _boxes: Array[Vector2i]
var _targets: Array[Vector2i]
var _target_boxes: Array[Vector2i]


var _layer_coords: Dictionary = {
	Constants.LayerType.Floor: _floor,
	Constants.LayerType.Walls: _wall,
	Constants.LayerType.Targets: _targets,
	Constants.LayerType.Boxes: _boxes,
	Constants.LayerType.TargetBoxes: _target_boxes,
}


func add_coord(coord: Vector2i, lt: Constants.LayerType) -> void:
	_layer_coords[lt].push_back(coord)
	pass


func get_tiles_for_layer(lt: Constants.LayerType) -> Array[Vector2i]:
	return _layer_coords[lt]
