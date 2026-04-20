class_name Player
extends CharacterBody2D


@onready var controller: PlayerController = $PlayerController
@onready var mover: PlayerMover = $PlayerMover
@onready var dash_component: DashComponent = $DashComponent
@onready var visuals: Node2D = $Visuals
@onready var front_shooter: ShooterComponent = $Visuals/FrontShooter
@onready var debug_label: Label = $DebugLabel


func _physics_process(delta: float) -> void:
	if controller.dash_pressed:
		dash_component.try_dash(controller.direction)
	if not dash_component.is_dashing:
		mover.move(controller.direction, delta)
	rotate_to()
	move_and_slide()
	front_shooter.shoot(controller.shoot_pressed)
	_debug()


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
