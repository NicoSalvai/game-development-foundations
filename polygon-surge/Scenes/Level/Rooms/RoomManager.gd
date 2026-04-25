class_name RoomManager
extends Node

signal room_cleared

@export var room_config: RoomConfig

var _alive_count: int = 0
var _current_wave_index: int = 0
var _spawn_points: Array[SpawnPoint] = []
var _is_running: bool = false
var _is_spawning: bool = false


func _ready() -> void:
	for child in get_parent().find_children("*", "SpawnPoint"):
		_spawn_points.append(child)
	SignalHub.enemy_died.connect(_on_enemy_died)


func start() -> void:
	if room_config == null:
		push_error("RoomManager '%s' has no RoomConfig assigned." % name)
		return
	if _spawn_points.is_empty():
		push_error("RoomManager '%s' found no SpawnPoints in parent." % name)
		return
	_is_running = true
	_current_wave_index = 0
	_launch_wave(_current_wave_index)


func _launch_wave(index: int) -> void:
	var wave: WaveConfig = room_config.waves[index]
	await get_tree().create_timer(wave.start_delay).timeout
	for entry in wave.entries:
		await _spawn_entry(entry)


func _spawn_entry(entry: WaveEntry) -> void:
	_is_spawning = true
	var candidates: Array[SpawnPoint] = _spawn_points.filter(
		func(sp: SpawnPoint) -> bool:
			return sp.category == entry.spawn_category
	)
	if candidates.is_empty():
		push_error("RoomManager: no SpawnPoints with category '%s'." % entry.spawn_category)
		_is_spawning = false
		return
	for i in entry.count:
		var spawn_point: SpawnPoint = candidates.pick_random()
		SignalHub.create_object.emit(spawn_point.get_spawn_position(), Vector2.ZERO, entry.enemy_type)
		_alive_count += 1
		if i < entry.count - 1:
			await get_tree().create_timer(entry.spawn_delay).timeout
	_is_spawning = false
	_check_wave_complete()


func _on_enemy_died() -> void:
	if not _is_running:
		return
	_alive_count -= 1
	_check_wave_complete()


func _check_wave_complete() -> void:
	if _is_spawning or _alive_count > 0:
		return
	_current_wave_index += 1
	if _current_wave_index >= room_config.waves.size():
		_is_running = false
		room_cleared.emit()
	else:
		_launch_wave(_current_wave_index)
