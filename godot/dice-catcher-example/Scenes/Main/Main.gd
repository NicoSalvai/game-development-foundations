extends Node2D

const GAME_OVER = preload("uid://bk0vibxoiqdum")
const DICE = preload("uid://djcvor28imc8k")
const STOPPABLE: String = "stoppable"
const DICE_SPAWN_MARGIN: float = 80.0
const DICE_SPAWN_OVERHEAD: float = 80.0

@onready var score_label: Label = $ScoreLabel
@onready var fox: Fox = $Fox
@onready var spawn_timer: Timer = $SpawnTimer
@onready var music: AudioStreamPlayer = $Music


var score: int = 0

func _ready() -> void:
	spawn_timer.timeout.connect(spawn_dice)
	fox.scored.connect(_on_scored)
	update_score_label()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()


func pause_all() -> void:
	music.stop()
	music.stream = GAME_OVER
	music.play()
	spawn_timer.stop()
	var stoppable: Array[Node] = get_tree().get_nodes_in_group(STOPPABLE)
	for node in stoppable:
		node.set_process(false)
		node.set_physics_process(false)


func spawn_dice() -> void:
	var new_dice: Dice = DICE.instantiate()
	new_dice.position = get_dice_initial_position();
	new_dice.hitted_bottom.connect(pause_all, ConnectFlags.CONNECT_ONE_SHOT)
	add_child(new_dice)


func get_dice_initial_position() -> Vector2:
	var right_limit: float = get_viewport_rect().end.x - DICE_SPAWN_MARGIN
	return Vector2(randf_range(DICE_SPAWN_MARGIN, right_limit), -DICE_SPAWN_OVERHEAD)

func update_score_label() -> void:
	score_label.text = "%04d" % score

func _on_scored() -> void:
	score += 1
	update_score_label()
