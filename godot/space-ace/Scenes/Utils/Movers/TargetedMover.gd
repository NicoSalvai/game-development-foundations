class_name TargetedMover
extends Mover

@export var target_group: String = Constants.PLAYER_GROUP

var _target: Node2D

func _ready() -> void:
	_target = get_tree().get_first_node_in_group(target_group)
	super._ready()

func setup_velocity() -> void:
	if !_target:
		return
	_velocity = speed * _parent.global_position.direction_to(_target.global_position)
