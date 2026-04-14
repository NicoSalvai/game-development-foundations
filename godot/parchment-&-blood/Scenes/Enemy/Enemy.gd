class_name Enemy
extends CharacterBody2D


@onready var hurt_box: HurtBox = $HurtBox
@onready var visuals: Node2D = $Visuals

var _player_ref: Player
var _sees_player: bool = true


func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	hurt_box.hit.connect(_on_hurt_box_hit)


func _physics_process(delta: float) -> void:
	if not _player_ref:
		return
	handle_look_at_player()


func handle_look_at_player() -> void:
	if _sees_player:
		visuals.look_at(_player_ref.global_position)
	

func _on_hurt_box_hit(damage: int, source: Node) -> void:
	handle_damage(damage)


func handle_damage(damage: int) -> void:
	die()


func die() -> void:
	SignalHub.on_create_enemy_death.emit(global_position)
	SignalHub.on_enemy_died.emit()
	queue_free()
