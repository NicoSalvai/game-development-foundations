extends Sprite2D

var manual_mode: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move based on Input
	if manual_mode:
		if Input.is_action_pressed("ui_left"):
			rotate(delta * -1.5)
		if Input.is_action_pressed("ui_right"):
			rotate(delta * 1.5)
		if Input.is_action_pressed("ui_up"):
			move_local_x(delta * 60.0)
	#Movement based on mouse position
	else:
		# Rotate to look at a Vector
		look_at(get_global_mouse_position())
		move_local_x(delta * 60)

	
	# Other inputs
	if Input.is_action_just_pressed("ui_accept"):
		#eating_sound.play()
		manual_mode = !manual_mode
