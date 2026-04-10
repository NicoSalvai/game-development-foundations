extends Camera2D

@export var shake_amount: float = 5.0
@export var shake_time: float = 0.3


func _ready() -> void:
	set_process(false)
	SignalHub.on_lives_change.connect(_on_lives_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	offset = Vector2(
		randf_range(-shake_amount, shake_amount), 
		randf_range(-shake_amount, shake_amount)
	)


func reset_camera() -> void:
	set_process(false)

func _on_lives_change(shake: bool) -> void:
	if shake:
		set_process(true)
		await get_tree().create_timer(shake_time).timeout
		reset_camera()
