class_name WaveManager
extends Node


const ENEMY_SCENES: Dictionary[Constants.EnemyType, PackedScene] = {
	Constants.EnemyType.ARCHER: preload("uid://dc15re8d8w4bm"),
	Constants.EnemyType.SWORD: preload("uid://cahxjof3arcub")
}

var spawn_points: Dictionary[Constants.WaveDirections, Array] = {
	Constants.WaveDirections.TOP: [],
	Constants.WaveDirections.LEFT: [],
	Constants.WaveDirections.BOTTOM: [],
	Constants.WaveDirections.RIGHT: []
}

@onready var enemies_holder: Node = $"../EnemiesHolder"
@export var wave_name: String = "TestWave"
@export var wave_data: WaveData
var _enemies_left: int = 0


func _ready() -> void:
	SignalHub.on_enemy_died.connect(_on_enemy_died)
	for child in get_children():
		if child is SpawnPoint:
			spawn_points[child.direction].append(child)
	start()


func start_next_wave() -> void:
	if !wave_data:
		return
		
	for sub_wave_data in wave_data.sub_wave_data_array:
		_enemies_left = 0
		for enemy in sub_wave_data.enemies:
			for i in range(enemy.count):
				_enemies_left += 1
				var dir: Constants.WaveDirections = enemy.directions.pick_random()
				var spawn_point: SpawnPoint = spawn_points[dir].pick_random()
				var new_enemy: Enemy = ENEMY_SCENES[enemy.type].instantiate()
				new_enemy.global_position = spawn_point.get_spawn_position()
				enemies_holder.add_child(new_enemy)
				await get_tree().create_timer(sub_wave_data.delay_between_enemies).timeout
			await get_tree().create_timer(sub_wave_data.delay_between_groups).timeout
		if wave_data.wait_for_completion and _enemies_left > 0:
			await SignalHub.on_wave_completed
		await get_tree().create_timer(wave_data.delay_before_next_wave).timeout
	SignalHub.on_level_ended.emit()

	
func start() -> void:
	wave_data = WaveLoader.load_wave_data(wave_name)
	start_next_wave()

func _on_enemy_died() -> void:
	if _enemies_left <= 0:
		return
	_enemies_left -= 1
	if _enemies_left == 0:
		SignalHub.on_wave_completed.emit()
