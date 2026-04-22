class_name Player
extends CharacterBody2D


@onready var controller: PlayerController = $PlayerController
@onready var mover: PlayerMover = $PlayerMover
@onready var dash_component: DashComponent = $DashComponent
@onready var visuals: Node2D = $Visuals
@onready var front_shooter: ShooterComponent = $Visuals/FrontShooter
@onready var debug_label: Label = $DebugLabel
@onready var hp_component: HPComponent = $HPComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_visuals: PlayerDamageVisuals = $Visuals/PlayerDamageVisuals
@onready var camera: Camera2D = $Camera2D
@onready var knockback_component: KnockbackComponent = $KnockbackComponent


func _ready() -> void:
	add_to_group(Constants.PLAYER_GROUP)


func _physics_process(delta: float) -> void:
	if controller.dash_pressed:
		dash_component.try_dash(controller.direction)
		knockback_component.cancel()
	if not dash_component.is_dashing:
		mover.move(controller.direction, delta)
	velocity += knockback_component.get_velocity()
	rotate_to()
	move_and_slide()
	_update_camera()
	if front_shooter.shoot(controller.shoot_pressed):
		animation_player.play("shoot")
	_debug()


func _update_camera() -> void:
	var aim_direction := (controller.aim_target - global_position).normalized()
	camera.update_lead(aim_direction, controller.direction)


func rotate_to() -> void:
	visuals.look_at(controller.aim_target)


func _debug() -> void:
	debug_label.text = "D (%.2f,%.2f), V (%.0f,%.0f)" % [
		controller.direction.x, controller.direction.y, velocity.x, velocity.y
	]
	debug_label.text += "\nAT (%.0f,%.0f)" % [
		controller.aim_target.x, controller.aim_target.y
	]
	debug_label.text += "\nCD (%.2f)" % [
		dash_component.get_cooldown_time()
	]
	debug_label.text += "\nHP (%d), DEAD (%s)" % [
		hp_component.current_hp, hp_component.is_dead()
	]


func _on_hurt_box_hitted(damage: int, source_position: Vector2) -> void:
	hp_component.take_damage(damage)
	damage_visuals.on_damaged(hp_component.current_hp)
	Utils.debug_log("Player hp %s" % hp_component.current_hp, name)
	var knockback_direction := source_position.direction_to(global_position)
	knockback_component.apply(knockback_direction)
	Utils.debug_log("Player hp %s" % hp_component.current_hp, name)


func _on_hp_component_died() -> void:
	Utils.debug_log("Player died", name) # TODO _on_died player
