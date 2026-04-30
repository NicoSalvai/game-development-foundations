class_name Orbis
extends CharacterBody2D

# ── Configuración ──────────────────────────────────────────────────────────────
@export var orbit_radius: float = 120.0
@export var throw_damage_threshold: int = 30
@export var throw_cooldown: float = 1.5
@export var part_return_time: float = 0.8
@export var minion_spawn_count: int = 2
@export var minion_spawn_radius: float = 80.0
@export var minion_spawn_interval: float = 4.0

signal intro_finished

# Rotación por fase [velocidad_base, cambio_cada_N_segundos]
const PHASE_ROTATION := {
	1: { "speed": 1.3,  "change_interval": 5.0 },
	2: { "speed": 2.0,  "change_interval": 3.0 },
	3: { "speed": 2.8,  "change_interval": 1.2 },
}

# Fire rate por fase (seteado en ShooterComponents)
const PHASE_FIRE_RATE := {
	1: 0.25,
	2: 0.18,
	3: 0.095,
}

# Shooters activos por fase (índices 0-5)
const PHASE_ACTIVE_SHOOTERS := {
	1: [0, 2, 4],
	2: [0, 1, 3, 4],
	3: [0, 1, 2, 3, 4, 5],
}

# Thresholds de HP donde se destruye una parte [porcentaje, cambia_fase]
const HP_THRESHOLDS := [
	{ "pct": 0.80, "change_phase": false },
	{ "pct": 0.60, "change_phase": true  },
	{ "pct": 0.40, "change_phase": false },
	{ "pct": 0.20, "change_phase": true  },
]

# ── Estado interno ─────────────────────────────────────────────────────────────
var _current_phase: int = 1
var _rotation_direction: float = 1.0
var _rotation_speed: float = 0.0
var _rotation_timer: float = 0.0
var _rotation_interval: float = 0.0
var _damage_accumulated: int = 0
var _can_throw: bool = true
var _next_threshold_index: int = 0
var _is_dead: bool = false

# ── Nodos ──────────────────────────────────────────────────────────────────────
@onready var hp_component: HPComponent = $HPComponent
@onready var hurt_box: HurtBox = $HurtBox
@onready var core: Node2D = $Core
@onready var shooters: Node2D = $Core/Shooters
@onready var parts: Node2D = $Parts
@onready var throw_cooldown_timer: Timer = $ThrowCooldownTimer
@onready var animation_player: AnimationPlayer = $Core/AnimationPlayer
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var minion_spawn_timer: Timer = $MinionSpawnTimer


func _ready() -> void:
	add_to_group(Constants.ORBIS_BOSS_GROUP)
	hp_component.died.connect(_on_died)
	hurt_box.hitted.connect(_on_hurt_box_hitted)
	throw_cooldown_timer.wait_time = throw_cooldown
	throw_cooldown_timer.timeout.connect(_on_throw_cooldown_timeout)
	_enter_phase(1)

func activate(pos: Vector2, _dir: Vector2) -> void:
	global_position = pos

func _physics_process(delta: float) -> void:
	if _is_dead:
		return
	_update_rotation(delta)
	_fire_active_shooters()


func _fire_active_shooters() -> void:
	var active_indices: Array = PHASE_ACTIVE_SHOOTERS[_current_phase]
	for i in shooters.get_child_count():
		if i in active_indices:
			shooters.get_child(i).get_shooter().shoot(true)


func play_intro() -> void:
	_is_dead = true          # bloquea _physics_process
	set_process(false)       # bloquea shooters
	for part in parts.get_children():
		part.set_physics_process(false)
	hurt_box.monitoring = false
	animation_player.play("intro")
	# Al terminar la animación, AnimationPlayer llama _on_intro_animation_finished
	# via Method Track


# ── Rotación ───────────────────────────────────────────────────────────────────
func _update_rotation(delta: float) -> void:
	_rotation_timer += delta
	if _rotation_timer >= _rotation_interval:
		_rotation_timer = 0.0
		_change_rotation_direction()

	core.rotation += _rotation_speed * _rotation_direction * delta


func _change_rotation_direction() -> void:
	_rotation_direction *= -1.0

	# En fase 3 cambia también la velocidad aleatoriamente y hace reverse brusco
	if _current_phase == 3:
		var phase_data: Dictionary = PHASE_ROTATION[3]
		_rotation_speed = randf_range(phase_data["speed"], phase_data["speed"] * 2.0)
		_rotation_interval = randf_range(1.0, phase_data["change_interval"])


func _update_shooter_aim() -> void:
	# Los shooters ya apuntan hacia afuera por su posición en la periferia,
	# la rotación del core los lleva consigo. No necesitan lógica adicional.
	pass


# ── Fases ──────────────────────────────────────────────────────────────────────
func _enter_phase(phase: int) -> void:
	_current_phase = phase
	var phase_data: Dictionary = PHASE_ROTATION[phase]
	_rotation_speed = phase_data["speed"]
	_rotation_interval = phase_data["change_interval"]
	_rotation_timer = 0.0

	_apply_active_shooters(phase)
	_apply_fire_rate(phase)
	if phase == 2:
		minion_spawn_timer.wait_time = minion_spawn_interval
		minion_spawn_timer.start()
	else:
		minion_spawn_timer.stop()


func _apply_active_shooters(phase: int) -> void:
	var active_indices: Array = PHASE_ACTIVE_SHOOTERS[phase]
	for i in shooters.get_child_count():
		var orbis_shooter: OrbisShooter = shooters.get_child(i)
		var is_active: bool = i in active_indices
		#orbis_shooter.visible = is_active
		orbis_shooter.get_shooter().set_process(is_active)
		orbis_shooter.modulate = "#ffffff" if is_active else "#3a3a3a"


func _apply_fire_rate(phase: int) -> void:
	var rate: float = PHASE_FIRE_RATE[phase]
	for orbis_shooter in shooters.get_children():
		var shooter = orbis_shooter.get_shooter()
		shooter.fire_rate = rate
		shooter.fire_timer.wait_time = rate


# ── Daño y thresholds ──────────────────────────────────────────────────────────
func _on_hurt_box_hitted(damage: int, source_position: Vector2, _knockback: float) -> void:
	hp_component.take_damage(damage)
	hurt_sound.play()
	if not animation_player.is_playing():
		animation_player.play("hit_flash")

	_damage_accumulated += damage
	_check_throw_trigger()
	_check_hp_thresholds()


func _check_hp_thresholds() -> void:
	if _next_threshold_index >= HP_THRESHOLDS.size():
		return

	var threshold: Dictionary = HP_THRESHOLDS[_next_threshold_index]
	if hp_component.percentage_hp <= threshold["pct"]:
		_next_threshold_index += 1
		_destroy_next_part()
		if threshold["change_phase"]:
			_enter_phase(_current_phase + 1)


func _destroy_next_part() -> void:
	# Destruye la primera parte viva que encuentre
	for part in parts.get_children():
		if part.is_alive():
			part.destroy()
			return


func _on_minion_spawn_timer_timeout() -> void:
	for i in minion_spawn_count:
		var angle := randf() * TAU
		var offset := Vector2(cos(angle), sin(angle)) * randf_range(minion_spawn_radius, minion_spawn_radius * 2.0)
		SignalHub.create_object.emit(
			global_position + offset,
			Vector2.ZERO,
			Constants.ObjectType.ENEMY_CHASER
		)

# ── Throw ──────────────────────────────────────────────────────────────────────
func _check_throw_trigger() -> void:
	if not _can_throw:
		return
	if _damage_accumulated < throw_damage_threshold:
		return

	_damage_accumulated = 0
	_can_throw = false
	throw_cooldown_timer.start()
	_launch_random_part()


func _launch_random_part() -> void:
	var player := get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	if not player:
		return

	# Elige una parte viva al azar
	var alive_parts: Array = parts.get_children().filter(func(p): return p.is_alive())
	if alive_parts.is_empty():
		return

	var target_part: Node2D = alive_parts.pick_random()
	target_part.launch(player.global_position, part_return_time)


func _on_throw_cooldown_timeout() -> void:
	_can_throw = true


# ── Muerte ─────────────────────────────────────────────────────────────────────
func _on_died() -> void:
	_is_dead = true
	# Detener todos los shooters
	for shooter in shooters.get_children():
		shooter.set_process(false)
	
	var alive_parts: Array = parts.get_children().filter(func(p): return p.is_alive())
	for active_part in alive_parts:
		active_part.destroy()
	
	hurt_box.set_deferred("monitorable", false)
	# La animación de muerte llama queue_free() al terminar via signal
	animation_player.play("death")


func spawn_death_explosions() -> void:
	var count: int = randi_range(3, 4)
	for i in count:
		var offset := Vector2(
			randf_range(-orbit_radius, orbit_radius),
			randf_range(-orbit_radius, orbit_radius)
		)
		SignalHub.create_object.emit(
			global_position + offset,
			Vector2.ZERO,
			Constants.ObjectType.ENEMY_DEATH
		)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		SignalHub.enemy_died.emit()
	elif anim_name == "intro":
		_is_dead = false
		set_process(true)
		for part in parts.get_children():
			part.set_physics_process(true)
		hurt_box.monitoring = true
		_enter_phase(1)
		intro_finished.emit()
