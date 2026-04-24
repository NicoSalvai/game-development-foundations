extends Node2D

@onready var object_factory: ObjectFactory = $ObjectFactory
@onready var bullet_pool: Pool = $BulletPool
@onready var bullet_pool_2: Pool = $BulletPool2
@onready var bullet_pool_3: Pool = $BulletPool3
@onready var enemy_bullet_pool: Pool = $EnemyBulletPool

var pools: Dictionary[Constants.ObjectType, Pool] = {}


func _ready() -> void:
	SignalHub.create_object.connect(_on_create_object)
	SignalHub.poolable_returned.connect(_on_poolable_returned)
	pools[bullet_pool.object_type] = bullet_pool
	pools[bullet_pool_2.object_type] = bullet_pool_2
	pools[bullet_pool_3.object_type] = bullet_pool_3
	pools[enemy_bullet_pool.object_type] = enemy_bullet_pool


func _on_create_object(pos: Vector2, dir: Vector2, object_type: Constants.ObjectType) -> void:
	if pools.has(object_type):
		pools[object_type].request(pos, dir)
	else:
		object_factory.create_and_add(object_type, pos, dir)


func _on_poolable_returned(node: Node, object_type: Constants.ObjectType) -> void:
	if pools.has(object_type):
		pools[object_type].object_returned(node)
	else:
		printerr("No pool registered for object_type: %s" % object_type)
