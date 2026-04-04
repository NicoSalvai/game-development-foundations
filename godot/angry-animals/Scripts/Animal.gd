class_name Animal


extends RigidBody2D


@onready var stretch_sound: AudioStreamPlayer2D = $StretchSound
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound
@onready var kick_sound: AudioStreamPlayer2D = $KickSound
@onready var arrow: Sprite2D = $Arrow


const DRAG_VECTOR_LIMIT: float = 60.0
const FORCE_MULT: float = 700.0
const _DRAG_LIMIT_MIN: Vector2 = Vector2(-60,0)
const _DRAG_LIMIT_MAX: Vector2 = Vector2(0,60)
const MAX_IMPULSE: Vector2 = Vector2(-60,60)


var _is_dragging: bool = false
var _drag_start: Vector2 = Vector2.ZERO
var _offset_drag: Vector2 = Vector2.ZERO
var _arrow_scale_x: float = 0.0


func _ready() -> void:
	body_shape_entered.connect(_on_body_shape_entered)
	sleeping_state_changed.connect(_on_sleeping_state_changed)
	input_event.connect(_on_input_event)
	_arrow_scale_x = arrow.scale.x


func _physics_process(_delta: float) -> void:
	if _is_dragging: handle_dragging()


func _unhandled_input(event: InputEvent) -> void:
	if _is_dragging and event.is_action_released("drag"): call_deferred("handle_end_dragging")


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag"): handle_start_dragging()


func handle_start_dragging() -> void:
	input_event.disconnect(_on_input_event)
	arrow.show()
	_drag_start = get_global_mouse_position()
	_offset_drag = _drag_start - position
	_is_dragging = true


func handle_end_dragging() -> void:
	_is_dragging = false
	freeze = false
	arrow.hide()
	launch_sound.play()
	var drag_vector = position - _drag_start
	apply_central_force(calculate_impulse(drag_vector))


func handle_dragging() -> void:
	var drag_vector = get_global_mouse_position() - _drag_start
	position = drag_vector.clamp(_DRAG_LIMIT_MIN, _DRAG_LIMIT_MAX) + _drag_start - _offset_drag
	if !stretch_sound.playing and !is_zero_approx(drag_vector.length()):
		stretch_sound.play()
	scale_arrow(position - (_drag_start - _offset_drag))
	
func scale_arrow(drag_vector: Vector2) -> void:
	var intensity: float = clamp(drag_vector.length() / MAX_IMPULSE.length(), 0.0, 1.0)
	arrow.scale.x = lerpf(_arrow_scale_x, _arrow_scale_x * 2, intensity)
	arrow.rotation = (drag_vector * -1 ).angle()


func calculate_impulse(drag_vector: Vector2) -> Vector2:
	return drag_vector * FORCE_MULT * -1


func animal_died() -> void:
	queue_free()
	SignalHub.emit_on_animal_died()


func _on_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if !kick_sound.playing:
		kick_sound.play()

func _on_sleeping_state_changed() -> void:
	for body in get_colliding_bodies():
		if body is Cup: body.die()
	animal_died()
	
	
