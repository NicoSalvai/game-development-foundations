class_name EnemyBase
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 30.0
@export var direction: float = 1.0
@export var points: int = 1
var _player_ref: FoxPlayer


func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP_NAME)
	if _player_ref == null:
		queue_free()


func _physics_process(delta: float) -> void:
	fallen_off_map()
	move_and_slide()


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = min(velocity.y + get_gravity().y * delta, Constants.MAX_FALL_SPEED)


func fallen_off_map() -> void:
	if global_position.y > Constants.Y_LIMIT:
		queue_free()


func die() -> void:
	SignalHub.emit_on_create_explosion(global_position)
	SignalHub.emit_on_create_pickup(global_position, points)
	set_physics_process(false)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_hit_box_area_entered(area: Area2D) -> void:
	die()
