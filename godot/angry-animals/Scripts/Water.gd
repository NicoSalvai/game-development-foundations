class_name Water


extends Area2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var splash_sound: AudioStreamPlayer2D = $SplashSound


func _ready() -> void:
	body_shape_entered.connect(_on_body_shape_entered)


func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Animal:
		splash_sound.global_position = body.global_position
		splash_sound.play()
		(body as Animal).animal_died()
	
