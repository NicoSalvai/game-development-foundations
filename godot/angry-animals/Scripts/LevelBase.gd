class_name LevelBase


extends Node


const ANIMAL = preload("uid://hry4tlce2bq2")


@onready var spawn: Marker2D = $Container/Spawn
@onready var game_ui: GameUI = $CanvasLayer/GameUI
@onready var container: Node = $Container


var total_cups: int = 0
var current_cups: int = 0
var level: int = 1
var attempt: int = -1


func _ready() -> void:
	SignalHub.on_animal_died.connect(spawn_animal)
	SignalHub.on_cup_destroyed.connect(_on_cup_destroyed)
	level = ScoreManager.level_selected
	spawn_animal()
	total_cups = get_tree().get_nodes_in_group(Cup.GROUP_NAME).size()
	current_cups = total_cups
	game_ui.set_level(level)


func spawn_animal() -> void:
	var animal: Animal = ANIMAL.instantiate()
	animal.position = spawn.position
	_on_made_attempt()
	call_deferred("add_animal", animal)


func add_animal(animal: Animal) -> void:
	container.add_child(animal)


func _on_cup_destroyed() -> void:
	current_cups -= 1
	if current_cups == 0:
		SignalHub.emit_level_completed()
		ScoreManager.set_score_for_current_level(attempt+1)


func _on_made_attempt() -> void:
	attempt += 1
	SignalHub.emit_attempts_updated(attempt)
