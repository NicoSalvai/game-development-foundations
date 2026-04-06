class_name PowerUp
extends Area2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var _speed: float = 150.0
@export var _power_up_type: = BrickDefinition.PowerUp.MULTI_BALL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(handle_exited_screen, CONNECT_ONE_SHOT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_local_y(delta * _speed)


func handle_exited_screen() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Paddle:
		SignalHub.power_up_picked_up.emit(_power_up_type)
		queue_free()
