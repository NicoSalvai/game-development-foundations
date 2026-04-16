class_name Level
extends Node2D

@onready var exit_button: CustomButton = $HUD/Control/MarginContainer/VBoxContainer/ExitButton
@onready var restart_button: CustomButton = $HUD/Control/MarginContainer/VBoxContainer/RestartButton
@onready var _floor: TileMapLayer = $TileLayers/Floor
@onready var _walls: TileMapLayer = $TileLayers/Walls
@onready var _targets: TileMapLayer = $TileLayers/Targets
@onready var _boxes: TileMapLayer = $TileLayers/Boxes
@onready var camera_2d: Camera2D = $Camera2D
@onready var player: AnimatedSprite2D = $Player

var game_over: bool = false

var tiles_atlas_coords: Dictionary[Constants.LayerType, Array] = {
	Constants.LayerType.Walls: [2],
	Constants.LayerType.Floor: [3,4,5,6,7,8],
	Constants.LayerType.Targets: [9],
	Constants.LayerType.Boxes: [1],
	Constants.LayerType.TargetBoxes: [0],
	Constants.LayerType.None: [-1]
}


var _tile_size: int = 32
var _player_tile: Vector2i = Vector2i.ZERO


func _ready() -> void:
	exit_button.function = GameManager.load_main
	restart_button.function = GameManager.load_level
	
	clear_tiles()
	_tile_size = _floor.tile_set.tile_size.x
	
	var current_level = LevelData.current_level_data
	setup_tiles(current_level)
	place_player_on_tile(current_level.get_player_start())
	setup_camera()


func clear_tiles() -> void:
	_floor.clear()
	_walls.clear()
	_targets.clear()
	_boxes.clear()


func setup_tiles(current_level) -> void:
	load_layer(_floor, current_level.get_tiles_for_layer(Constants.LayerType.Floor), Constants.LayerType.Floor)
	load_layer(_walls, current_level.get_tiles_for_layer(Constants.LayerType.Walls), Constants.LayerType.Walls)
	load_layer(_targets, current_level.get_tiles_for_layer(Constants.LayerType.Targets), Constants.LayerType.Targets)
	load_layer(_boxes, current_level.get_tiles_for_layer(Constants.LayerType.Boxes), Constants.LayerType.Boxes)
	load_layer(_boxes, current_level.get_tiles_for_layer(Constants.LayerType.TargetBoxes), Constants.LayerType.TargetBoxes)

func load_layer(layer: TileMapLayer, layer_cell_positions: Array[Vector2i], type: Constants.LayerType) -> void:
	for cell_pos in layer_cell_positions:
		set_cell(layer, cell_pos, type)

func set_cell(layer: TileMapLayer, cell: Vector2i, type: Constants.LayerType) -> void:
	var x_atlas_coord: int = tiles_atlas_coords[type].pick_random()
	layer.set_cell(cell, 0, Vector2i(x_atlas_coord, 0))


func place_player_on_tile(tile_coord: Vector2i) -> void:
	_player_tile = tile_coord
	player.global_position = _player_tile * _tile_size


func setup_camera() -> void:
	var center: Vector2i = _floor.get_used_rect().get_center()
	camera_2d.global_position = Vector2(center.x * _tile_size, center.y * _tile_size)


func get_input_direction() -> Vector2i:
	var md: Vector2i = Vector2i.ZERO
	if Input.is_action_just_pressed("ui_left"):
		md = Vector2i.LEFT
		player.flip_h = true
	elif Input.is_action_just_pressed("ui_right"):
		md = Vector2i.RIGHT
		player.flip_h = false
	elif Input.is_action_just_pressed("ui_up"):
		md = Vector2i.UP
	elif Input.is_action_just_pressed("ui_down"):
		md = Vector2i.DOWN
	return md


func _unhandled_input(event: InputEvent) -> void:
	if game_over:
		return
	
	var md: Vector2i = get_input_direction()
	if md != Vector2i.ZERO:
		move_player(md)

func check_game_over() -> void:
	for t in _targets.get_used_cells():
		if !cell_is_box(t):
			return
	game_over = true

func move_player(md: Vector2i) -> void:
	var dest: Vector2i = _player_tile + md
	
	if cell_is_wall(dest):
		return
	
	if cell_is_box(dest):
		if !box_can_move(dest, md):
			return
		move_box(dest, md)
	
	place_player_on_tile(dest)
	check_game_over()

func cell_is_wall(cell: Vector2i) -> bool:
	return _walls.get_cell_tile_data(cell) != null

func cell_is_box(cell: Vector2i) -> bool:
	return _boxes.get_cell_tile_data(cell) != null

func cell_is_target(cell: Vector2i) -> bool:
	return _targets.get_cell_tile_data(cell) != null

func cell_is_empty(cell: Vector2i) -> bool:
	return !cell_is_wall(cell) and !cell_is_box(cell)

func box_can_move(box_cell: Vector2i, md: Vector2i) -> bool:
	var dest: Vector2i = box_cell + md
	return cell_is_empty(dest)
	
func move_box(box_cell: Vector2i, md: Vector2i) -> void:
	var dest: Vector2i = box_cell + md
	_boxes.erase_cell(box_cell)
	if cell_is_target(dest):
		set_cell(_boxes, dest, Constants.LayerType.TargetBoxes)
	else:
		set_cell(_boxes, dest, Constants.LayerType.Boxes)
		
