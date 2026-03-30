extends Node2D

class_name Pipes

static var pipe_speed: float = -150.0

@onready var screen_notifier: VisibleOnScreenNotifier2D = $ScreenNotifier
@onready var ttl_timer: Timer = $TtlTimer
@onready var upper_pipe: Area2D = $"Upper Pipe"
@onready var lower_pipe: Area2D = $"Lower Pipe"
@onready var laser: Area2D = $Laser
@onready var score_sound: AudioStreamPlayer = $ScoreSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.tappy_plane_died.connect(_on_tappy_plane_died)
	screen_notifier.screen_exited.connect(_remove_pipes)
	ttl_timer.timeout.connect(_remove_pipes)
	upper_pipe.body_entered.connect(_on_body_entered_pipe)
	lower_pipe.body_entered.connect(_on_body_entered_pipe)
	laser.body_exited.connect(_on_body_exited_laser)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(delta * pipe_speed)


func _remove_pipes() -> void:
	set_process(false)
	queue_free()


func _on_body_entered_pipe(body: Node2D) -> void:
	if body is Tappy:
		body.die()


func _on_body_exited_laser(body: Node2D) -> void:
	if body is Tappy:
		disconnect_laser()
		score_sound.play()
		SignalBus.emit_point_scored()
 

func _on_tappy_plane_died() -> void:
	disconnect_laser()


func disconnect_laser() -> void:
	if laser.body_exited.is_connected(_on_body_exited_laser):
		laser.body_exited.disconnect(_on_body_exited_laser)
