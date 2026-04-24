class_name EnemySpikeBall
extends EnemyBase

@onready var spike_ball_mover: SpikeBallMover = $SpikeBallMover
@onready var visuals: Node2D = $Visuals
@onready var hit_box: HitBox = $Visuals/HitBox
@onready var damage_visuals: DamageVisuals = $Visuals/DamageVisuals

var _player: CharacterBody2D


func _ready() -> void:
	super._ready()
	_player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	hit_box.hitted.connect(_on_hit_box_hitted)


func _physics_process(delta: float) -> void:
	if not _player:
		return
	spike_ball_mover.move(_player.global_position, delta)
	visuals.rotation += spike_ball_mover.get_spin_speed() * delta
	move_and_slide()


func _on_hit_box_hitted(node: Node2D, _is_area: bool) -> void:
	if node == _player:
		spike_ball_mover.on_player_hit()


func _on_hurt_box_hitted(damage: int, source_position: Vector2, knockback_strength: float) -> void:
	super(damage, source_position, knockback_strength)
	damage_visuals.on_damaged(hp_component.percentage_hp, source_position)
