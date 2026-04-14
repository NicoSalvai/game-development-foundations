class_name ObjectMaker
extends Node

const ARROW_IMPACT = preload("uid://b2kkaeetm38uk")
const ENEMY_DEATH = preload("uid://bgqwopdlh7a6b")


func _ready() -> void:
	SignalHub.on_create_arrow_impact.connect(_on_create_arrow_impact)
	SignalHub.on_create_enemy_death.connect(_on_create_enemy_death)


func _on_create_arrow_impact(pos: Vector2) -> void:
	var arrow_impact = ARROW_IMPACT.instantiate()
	arrow_impact.position = pos
	add_child(arrow_impact)

func _on_create_enemy_death(pos: Vector2) -> void:
	var enemy_death: EnemyDeath = ENEMY_DEATH.instantiate()
	enemy_death.position = pos
	add_child(enemy_death)
