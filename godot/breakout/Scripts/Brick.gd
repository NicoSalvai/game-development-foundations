class_name Brick
extends StaticBody2D

const ELEMENT_BLUE_RECTANGLE = preload("uid://dsn2c8hmgtckj")
const ELEMENT_GREY_RECTANGLE = preload("uid://bl2e3gifxap3g")
const ELEMENT_PURPLE_RECTANGLE = preload("uid://dt3uepp1xg2l8")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var definition: BrickDefinition = BrickDefinition.new()

var _health: int = 1

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	_health = definition.max_health
	match definition.color:
		BrickDefinition.BrickColor.GREY:
			sprite_2d.texture = ELEMENT_GREY_RECTANGLE
		BrickDefinition.BrickColor.BLUE:
			sprite_2d.texture = ELEMENT_BLUE_RECTANGLE
		BrickDefinition.BrickColor.PURPLE:
			sprite_2d.texture = ELEMENT_PURPLE_RECTANGLE


func on_ball_collision(ball: Ball, collision: KinematicCollision2D) -> void:
	ball.handle_default_collision(collision)
	if !definition.is_unbreakable:
		take_damage(ball.damage)


func take_damage(damage: int) -> void:
	_health -= damage
	if _health <= 0:
		die()


func die() -> void:
	collision_shape_2d.disabled = true
	SignalHub.brick_died.emit(definition.points)
	animation_player.play("die")
	if definition.power_up != BrickDefinition.PowerUp.NONE:
		SignalHub.spawn_power_up.emit(global_position, definition.power_up)


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "die":
		queue_free()


func get_width() -> float:
	var shape = collision_shape_2d.shape as RectangleShape2D
	return shape.size.x
