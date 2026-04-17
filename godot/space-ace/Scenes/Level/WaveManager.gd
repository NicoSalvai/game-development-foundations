class_name WaveManager
extends Node


@export var enabled: bool = true
@export var paths_list: Array[Path2D] = []
@export var waves_list: Array[Wave] = []

@onready var wave_timer: Timer = $WaveTimer
@onready var ship_timer: Timer = $ShipTimer


var _current_path: Path2D
var _current_wave_index: int = -1
var _current_wave: Wave
var _enemies_spawned: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !enabled: return
	start_next_wave()


func start_next_wave() -> void:
	_current_wave_index = (_current_wave_index + 1 ) % waves_list.size()
	_current_wave = waves_list[_current_wave_index]
	_current_path = paths_list.pick_random()
	_enemies_spawned = 0
	ship_timer.start(_current_wave.spwan_interval)


func _on_wave_timer_timeout() -> void:
	start_next_wave()


func _on_ship_timer_timeout() -> void:
	var enemy: EnemyBase = _current_wave.enemy_scene.instantiate()
	_current_path.add_child(enemy)
	_enemies_spawned += 1
	if _enemies_spawned == _current_wave.enemy_count:
		ship_timer.stop()
		wave_timer.start(_current_wave.wave_interval)
	else:
		ship_timer.start()
