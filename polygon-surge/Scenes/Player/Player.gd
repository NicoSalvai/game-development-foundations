class_name Player
extends CharacterBody2D

enum WeaponMode { PISTOL, SNIPER, SHOTGUN }

@onready var controller: PlayerController = $PlayerController
@onready var mover: PlayerMover = $PlayerMover
@onready var dash_component: DashComponent = $DashComponent
@onready var visuals: Node2D = $Visuals
@onready var front_shooter: ShooterComponent = $Visuals/FrontShooter
@onready var hp_component: HPComponent = $HPComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_visuals: PlayerDamageVisuals = $Visuals/PlayerDamageVisuals
@onready var camera: Camera2D = $Camera2D
@onready var knockback_component: KnockbackComponent = $KnockbackComponent
@onready var dash_visuals: DashVisuals = $Visuals/DashVisuals
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var dash_sound: AudioStreamPlayer2D = $DashSound
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var player_death_visuals: PlayerDeathVisuals = $Visuals/PlayerDeathVisuals
@onready var hurt_box: HurtBox = $Visuals/HurtBox
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var charged_shooter: ChargedShooterComponent = $Visuals/ChargedShooterComponent
@onready var sniper_sound: AudioStreamPlayer2D = $SniperSound
@onready var charge_sound: AudioStreamPlayer2D = $ChargeSound
@onready var spread_shooter: SpreadShooterComponent = $Visuals/SpreadShooterComponent


var _is_dead: bool = false
var _weapon_mode: WeaponMode = WeaponMode.PISTOL


func _ready() -> void:
	add_to_group(Constants.PLAYER_GROUP)
	charged_shooter.fired.connect(_on_sniper_fired)


func _physics_process(delta: float) -> void:
	if _is_dead:
		return
	if Input.is_action_just_pressed("switch"):
		_toggle_weapon()

	if controller.dash_pressed:
		if dash_component.try_dash(controller.direction):
			dash_sound.play()
			dash_visuals.play_dash(controller.direction)
			knockback_component.cancel()
	if not dash_component.is_dashing:
		mover.move(controller.direction, delta)
	velocity += knockback_component.get_velocity()
	rotate_to()
	move_and_slide()
	_update_camera()
	_handle_shooting()

func _handle_shooting() -> void:
	match _weapon_mode:
		WeaponMode.SHOTGUN:
			if spread_shooter.shoot(controller.shoot_pressed):
				animation_player.play("shotgun_shoot")
				shoot_sound.play()
				camera.add_trauma(0.2)
		WeaponMode.PISTOL:
			if front_shooter.shoot(controller.shoot_pressed):
				animation_player.play("shoot")
				shoot_sound.play()
				camera.add_trauma(0.1)
		WeaponMode.SNIPER:
			charged_shooter.shoot(controller.shoot_pressed)
			if controller.shoot_pressed and charged_shooter.get_charge_ratio() > 0.0:
				if not animation_player.current_animation == "sniper_charge" and charged_shooter.get_charge_ratio() < 0.5:
					animation_player.play("sniper_charge")
					charge_sound.play()
			elif not controller.shoot_pressed:
				if animation_player.current_animation == "sniper_charge" or charged_shooter.get_charge_ratio() > 0.0:
					animation_player.play("RESET_SNIPER")
					charge_sound.stop()
				pass


func _update_camera() -> void:
	var aim_direction := (controller.aim_target - global_position).normalized()
	camera.update_lead(aim_direction, controller.direction)


func rotate_to() -> void:
	visuals.look_at(controller.aim_target)


func _on_hurt_box_hitted(damage: int, source_position: Vector2, knockback_strength: float) -> void:
	hurt_sound.play()
	camera.add_trauma(0.5)
	hp_component.take_damage(damage)
	damage_visuals.on_damaged(hp_component.percentage_hp)
	var knockback_direction := source_position.direction_to(global_position)
	knockback_component.apply(knockback_direction, knockback_strength)


func _on_hp_component_died() -> void:
	death_sound.play()
	_is_dead = true
	hurt_box.set_deferred("monitorable", false)
	hurt_box.set_deferred("monitoring", false)
	camera.add_trauma(1)
	player_death_visuals.play_death(func():
		SignalHub.game_over.emit()
	)


func _toggle_weapon() -> void:
	if _weapon_mode == WeaponMode.PISTOL:
		_weapon_mode = WeaponMode.SNIPER
		animation_player.play("sniper_morph")
	elif _weapon_mode == WeaponMode.SNIPER:
		_weapon_mode = WeaponMode.SHOTGUN
		animation_player.play("shotgun_morph")
	elif _weapon_mode == WeaponMode.SHOTGUN:
		_weapon_mode = WeaponMode.PISTOL
		animation_player.play("pistol_morph")

func _on_sniper_fired() -> void:
	charge_sound.stop()
	animation_player.play("sniper_shoot")
	sniper_sound.play()
	camera.add_trauma(0.3)
