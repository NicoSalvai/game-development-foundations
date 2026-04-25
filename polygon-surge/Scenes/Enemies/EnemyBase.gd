class_name EnemyBase
extends CharacterBody2D

@onready var hp_component: HPComponent = $HPComponent
@onready var hurt_box: HurtBox = $Visuals/HurtBox
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound


func _ready() -> void:
	hp_component.died.connect(_on_died)
	hurt_box.hitted.connect(_on_hurt_box_hitted)

func activate(pos: Vector2, _dir: Vector2) -> void:
	global_position = pos

func _on_hurt_box_hitted(damage: int, source_position: Vector2, knockback_strength: float) -> void:
	hp_component.take_damage(damage)
	hurt_sound.play()


func _on_died() -> void:
	SignalHub.create_object.emit(global_position, Vector2.ZERO, Constants.ObjectType.ENEMY_DEATH)
	SignalHub.enemy_died.emit()
	queue_free()
