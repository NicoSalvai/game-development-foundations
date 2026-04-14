extends Node2D

@onready var floor_tile_map_layer: TileMapLayer = $FloorTileMapLayer
@onready var player: Player = $PlayersHolder/Player

func _ready() -> void:
	var used_rect: Rect2i = floor_tile_map_layer.get_used_rect()
	var tile_size: Vector2i = floor_tile_map_layer.tile_set.tile_size
	var bounds_pos: Vector2 = Vector2(used_rect.position * tile_size)
	var bounds_size: Vector2 = Vector2(used_rect.size * tile_size)
	player.setup_camera(bounds_pos, bounds_size)
