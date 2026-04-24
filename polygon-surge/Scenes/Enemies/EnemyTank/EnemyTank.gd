class_name EnemyTank
extends EnemyBase

@export var rotation_speed: float = 1.2

@onready var tank_mover: TankMover = $TankMover
@onready var visuals: Node2D = $Visuals
@onready var damage_visuals: DamageVisuals = $Visuals/DamageVisuals
@onready var shooters: Array[ShooterComponent] = [
	$Visuals/ShooterComponent,
	$Visuals/ShooterComponent2,
	$Visuals/ShooterComponent3,
	$Visuals/ShooterComponent4,
]

var _player: CharacterBody2D


func _ready() -> void:
	super._ready()
	_player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)


func _physics_process(delta: float) -> void:
	if not _player:
		return
	visuals.rotation += rotation_speed * delta
	tank_mover.move(_player.global_position, delta)
	for shooter in shooters:
		shooter.shoot(true)
	move_and_slide()


func _on_hurt_box_hitted(damage: int, source_position: Vector2, knockback_strength: float) -> void:
	super(damage, source_position, knockback_strength)
	damage_visuals.on_damaged(hp_component.percentage_hp, source_position)
