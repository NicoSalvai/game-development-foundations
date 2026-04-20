class_name EnemyChaser
extends EnemyBase

@onready var chaser_mover: ChaserMover = $ChaserMover
@onready var visuals: Node2D = $Visuals

var _player: CharacterBody2D

func _ready() -> void:
	super._ready()
	_player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)


func _physics_process(delta: float) -> void:
	if not _player:
		return
	rotate_to()
	chaser_mover.move(_player.global_position, delta)
	move_and_slide()
	_debug()


func rotate_to() -> void:
	visuals.look_at(_player.global_position)

func _debug() -> void:
	super()
	debug_label.text += "D (%.2f,%.2f), V (%.0f,%.0f)" % [
		chaser_mover.direction.x, chaser_mover.direction.y, velocity.x, velocity.y
	]
