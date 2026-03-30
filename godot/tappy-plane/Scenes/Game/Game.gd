extends Node

const PIPES = preload("uid://0r4c06buxeca")

@onready var pipes_holder: Node = $PipesHolder
@onready var lower_spawn: Marker2D = $LowerSpawn
@onready var upper_spawn: Marker2D = $UpperSpawn
@onready var spawn_timer: Timer = $SpawnTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.start()
	spawn_timer.timeout.connect(spawn_pipe)	


func spawn_pipe() -> void:
	var new_pipes: Pipes = PIPES.instantiate()
	var initial_x = upper_spawn.position.x;
	var initial_y = randf_range(upper_spawn.position.y, lower_spawn.position.y)
	new_pipes.position = Vector2(initial_x, initial_y)
	pipes_holder.add_child(new_pipes)
