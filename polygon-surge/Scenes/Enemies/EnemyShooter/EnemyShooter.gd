class_name EnemyShooter
extends EnemyBase

@export var shoot_range: float = 220.0

@onready var kite_mover: KiteMover = $KiteMover
@onready var visuals: Node2D = $Visuals
@onready var shooter_component: ShooterComponent = $Visuals/ShooterComponent
@onready var damage_visuals: DamageVisuals = $Visuals/DamageVisuals
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

var _player: CharacterBody2D


func _ready() -> void:
	super._ready()
	_player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)


func _physics_process(delta: float) -> void:
	if not _player:
		return
	visuals.look_at(_player.global_position)
	kite_mover.move(_player.global_position, delta)
	var distance := global_position.distance_to(_player.global_position)
	if distance <= shoot_range:
		if shooter_component.shoot(true):
			shoot_sound.play()
	move_and_slide()


func _on_hurt_box_hitted(damage: int, source_position: Vector2, knockback_strength: float) -> void:
	super(damage, source_position, knockback_strength)
	damage_visuals.on_damaged(hp_component.percentage_hp, source_position)
