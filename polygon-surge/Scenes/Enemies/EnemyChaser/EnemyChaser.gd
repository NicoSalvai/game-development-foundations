class_name EnemyChaser
extends EnemyBase

@onready var chaser_mover: ChaserMover = $ChaserMover
@onready var visuals: Node2D = $Visuals
@onready var chaser_damage_visuals: ChaserDamageVisuals = $Visuals/ChaserDamageVisuals

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


func _on_hurt_box_hitted(damage: int, _source_position: Vector2) -> void:
	super(damage, _source_position)
	chaser_damage_visuals.on_damaged(hp_component.current_hp)
