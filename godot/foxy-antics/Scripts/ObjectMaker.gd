class_name ObjectMaker
extends Node2D

const SCENES: Dictionary[Constants.ObjectType, PackedScene] = {
	Constants.ObjectType.ENEMY_BULLET: preload("uid://du631734evx4a"),
	Constants.ObjectType.PLAYER_BULLET: preload("uid://dym33peixhod8"),
	Constants.ObjectType.PICKUP: preload("uid://dou3if2gc7sge"),
	Constants.ObjectType.EXPLOSION: preload("uid://34325d178plc")
}

func _enter_tree() -> void:
	SignalHub.on_create_bullet.connect(_on_create_bullet)
	SignalHub.on_create_object.connect(_on_create_object)


func _on_create_bullet(pos: Vector2, direction: Vector2, speed: float, type: Constants.ObjectType) -> void:
	if !SCENES.has(type):
		return
	var bullet: BaseBullet = SCENES[type].instantiate()
	bullet.setup(pos, direction, speed) 
	add_child(bullet)


func _on_create_object(pos: Vector2, type: Constants.ObjectType, points: int = 0) -> void:
	if !SCENES.has(type):
		return
	var object = SCENES[type].instantiate()
	if points != 0:
		object.setup(pos, points) 
	else:
		object.setup(pos)
	call_deferred("add_child", object)
