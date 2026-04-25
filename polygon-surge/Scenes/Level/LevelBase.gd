class_name LevelBase
extends Node2D

signal level_cleared

@export var rooms: Array[RoomBase] = []

@onready var object_factory: ObjectFactory = $ObjectFactory
@onready var bullet_pool: Pool = $BulletPool
@onready var bullet_pool_2: Pool = $BulletPool2
@onready var bullet_pool_3: Pool = $BulletPool3
@onready var enemy_bullet_pool: Pool = $EnemyBulletPool
@onready var tile_map_layer: TileMapLayer = $Rooms/TileMapLayer

var pools: Dictionary[Constants.ObjectType, Pool] = {}
var _current_room_index: int = 0


func _ready() -> void:
	SignalHub.create_object.connect(_on_create_object)
	SignalHub.poolable_returned.connect(_on_poolable_returned)
	pools[bullet_pool.object_type] = bullet_pool
	pools[bullet_pool_2.object_type] = bullet_pool_2
	pools[bullet_pool_3.object_type] = bullet_pool_3
	pools[enemy_bullet_pool.object_type] = enemy_bullet_pool
	_start_room(0)
	hide_corridors()


func _start_room(index: int) -> void:
	var room: RoomBase = rooms[index]
	room.room_cleared.connect(_on_room_cleared, CONNECT_ONE_SHOT)
	room.start()


func _on_room_cleared() -> void:
	if _current_room_index >= rooms.size() -1:
		level_cleared.emit()
		return
	rooms[_current_room_index].exit_door.open()
	rooms[_current_room_index + 1].entry_door.open()
	rooms[_current_room_index + 1].entry_door.player_crossed.connect(_on_corridor_player_exited, CONNECT_ONE_SHOT)
	show_corridors()


func _on_corridor_player_exited() -> void:
	hide_corridors()
	_current_room_index += 1
	_start_room(_current_room_index)
	
	
func show_corridors() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(tile_map_layer, "modulate:a", 1.0, 0.3)

func hide_corridors() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(tile_map_layer, "modulate:a", 0.0, 0.3)


func _on_create_object(pos: Vector2, dir: Vector2, object_type: Constants.ObjectType) -> void:
	if pools.has(object_type):
		pools[object_type].request(pos, dir)
	else:
		object_factory.create_and_add(object_type, pos, dir)


func _on_poolable_returned(node: Node, object_type: Constants.ObjectType) -> void:
	if pools.has(object_type):
		pools[object_type].object_returned(node)
	else:
		printerr("No pool registered for object_type: %s" % object_type)
