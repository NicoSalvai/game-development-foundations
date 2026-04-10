class_name DevilBoss
extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hit_box: Area2D = $Visuals/HitBox
@onready var trigger: Area2D = $Trigger
@onready var shooter: Shooter = $Visuals/Shooter
@onready var visuals: Node2D = $Visuals
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
var _player_ref: FoxPlayer
var _invincible: bool = false

@export var lives: int = 2
@export var points: int = 5


func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP_NAME)
	if _player_ref == null:
		queue_free()

func _on_trigger_area_entered(_area: Area2D) -> void:
	animation_tree["parameters/conditions/on_trigger"] = true
	hit_box.set_deferred("monitorable", true)
	hit_box.set_deferred("monitoring", true)


func shoot() -> void:
	var dir = hit_box.global_position.direction_to(_player_ref.global_position)
	shooter.shoot(dir)


func _on_hit_box_area_entered(_area: Area2D) -> void:
	take_damage()

func take_damage() -> void:
	if _invincible:
		return
	_invincible = true
	reduce_lives()
	tween_on_hit()


func tween_on_hit() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_callback(func():state_machine.travel("Hit"))
	tween.parallel().tween_property(visuals, "position", Vector2.ZERO, 2.0)
	tween.tween_interval(0.25)
	tween.tween_callback(func():_invincible = false)

func reduce_lives() -> void:
	lives -= 1
	if lives <= 0:
		SignalHub.emit_on_create_pickup(global_position + Vector2(-15.0,0.0), points)
		SignalHub.emit_on_create_pickup(global_position + Vector2(15.0,0.0), points)
		SignalHub.emit_on_create_pickup(global_position + Vector2(0.0,-15.0), points)
		SignalHub.emit_on_create_explosion(global_position + Vector2(-15.0,0.0))
		SignalHub.emit_on_create_explosion(global_position + Vector2(15.0,0.0))
		SignalHub.emit_on_create_explosion(global_position + Vector2(0.0,-15.0))
		SignalHub.emit_on_boss_killed()
		queue_free()
