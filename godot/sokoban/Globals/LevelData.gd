extends Node

const LEVEL_DATA_PATH: String = "res://Data/level_data.json"

var all_level_data: Array[String]
var current_level_data: LevelLayout


func _enter_tree() -> void:
	load_all_level_data()

func load_all_level_data() -> void:
	var file: FileAccess = FileAccess.open(LEVEL_DATA_PATH, FileAccess.READ)
	
	if !file:
		return
	
	var json_data: Dictionary = JSON.parse_string(file.get_as_text())
	
	all_level_data = []
	for ln in json_data.keys():
		all_level_data.append(ln)
	

func load_level_data(level: String) -> void:
	var file: FileAccess = FileAccess.open(LEVEL_DATA_PATH, FileAccess.READ)
	
	if !file:
		return
	
	var json_data: Dictionary = JSON.parse_string(file.get_as_text())
	
	var level_data: Dictionary = json_data[level]
	if !level_data:
		return
	
	current_level_data = setup_level(level_data)


func setup_level(raw_level_data: Dictionary) -> LevelLayout:
	var level_layout = LevelLayout.new()
	level_layout.set_player_start(raw_level_data.player_start.x, raw_level_data.player_start.y)
	
	var raw_tiles = raw_level_data.tiles
	for key in raw_tiles.keys():
		for tile in raw_tiles[key]:
			var layer_type: Constants.LayerType = Constants.LayerType.get(key)
			if !layer_type:
				continue
			level_layout.add_tile_to_layer(tile.x, tile.y, layer_type)
	
	return level_layout
