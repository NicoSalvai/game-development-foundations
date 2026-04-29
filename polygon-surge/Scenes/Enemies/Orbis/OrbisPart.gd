class_name OrbisPart
extends Node2D

# ── Configuración ──────────────────────────────────────────────────────────────
@export var orbit_radius: float = 80.0
@export var orbit_index: int = 0        # 0-5, define el ángulo base en órbita

# ── Estado ─────────────────────────────────────────────────────────────────────
enum State { ORBITING, LAUNCHED, STUCK, RETURNING }

var _state: State = State.ORBITING
var _alive: bool = true
var _orbit_angle: float = 0.0

# ── Nodos ──────────────────────────────────────────────────────────────────────
@onready var hit_box: HitBox = $HitBox


func _ready() -> void:
	_orbit_angle = (TAU / 6.0) * orbit_index
	hit_box.hitted.connect(_on_hit_box_hitted)


func _physics_process(delta: float) -> void:
	if not _alive or _state != State.ORBITING:
		return
	var core: Node2D = get_parent().get_parent().get_node("Core")
	var angle: float = core.rotation + _orbit_angle
	position = Vector2(cos(angle), sin(angle)) * orbit_radius
	rotation = angle + PI / 2.0


# ── API pública ────────────────────────────────────────────────────────────────
func is_alive() -> bool:
	return _alive


func launch(target_pos: Vector2, return_time: float) -> void:
	if not _alive or _state != State.ORBITING:
		return

	_state = State.LAUNCHED
	var direction: Vector2 = (target_pos - global_position).normalized()
	var distance: float = global_position.distance_to(target_pos)

	var tween := create_tween()
	tween.tween_property(self, "global_position", target_pos, distance / 600.0)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): _on_stuck(return_time))


func destroy() -> void:
	if not _alive:
		return
	_alive = false
	_state = State.ORBITING  # evita que _physics_process siga corriendo
	hit_box.set_process(false)
	SignalHub.create_object.emit(global_position, Vector2.ZERO, Constants.ObjectType.ORBIS_PART_DEATH)
	queue_free()


# ── Interno ────────────────────────────────────────────────────────────────────
func _on_stuck(return_time: float) -> void:
	_state = State.STUCK

	var tween := create_tween()
	tween.tween_interval(return_time)
	tween.tween_callback(_return_to_orbit)


func _return_to_orbit() -> void:
	_state = State.RETURNING

	# Calculamos la posición objetivo actual en órbita
	var core: Node2D = get_parent().get_parent().get_node("Core")
	var angle: float = core.rotation + _orbit_angle
	var target_pos: Vector2 = get_parent().get_parent().global_position \
		+ Vector2(cos(angle), sin(angle)) * orbit_radius

	var tween := create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.4)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): _state = State.ORBITING)


func _on_hit_box_hitted(node: Node2D, _is_area: bool) -> void:
	# Solo nos importa el player — el daño lo maneja el HurtBox del player
	pass
