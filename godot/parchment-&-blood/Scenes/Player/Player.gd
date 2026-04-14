class_name Player
extends CharacterBody2D

const SMOOTH_FACTOR = 4.0
const SPEED = 300.0
const STOP_SPEED = 1000.0
const SHOOT_COOLDOWN: float = 0.5

@onready var debug_label: Label = $DebugLabel
@onready var controller: Node = $PlayerController
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var shooter: Shooter = $Shooter
@onready var hurt_box: HurtBox = $HurtBox

var is_aiming: bool = false
var finished_aiming: bool = false

func _ready() -> void:
	add_to_group(Constants.PLAYER_GROUP)
	hurt_box.hit.connect(_on_hurt_box_hit)
	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_aiming()
	handle_shoot()
	visuals.look_at(get_global_mouse_position())
	debug_label_load()
	move_and_slide()


func handle_movement(delta: float) -> void:
	if controller.direction != Vector2.ZERO:
		velocity = lerp(velocity, controller.direction * SPEED, SMOOTH_FACTOR * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, STOP_SPEED * delta)


func handle_shoot() -> void:
	if controller.shoot and finished_aiming and is_aiming:
		shoot()


func shoot() -> void:
	shooter.shoot(get_global_mouse_position())
	animation_player.play("re_aim")
	finished_aiming = false


func handle_aiming() -> void:
	if controller.aiming and !is_aiming:
		animation_player.play("aim")
		is_aiming = true
	elif !controller.aiming and is_aiming:
		is_aiming = false
		finished_aiming = false
		animation_player.play("RESET")


func debug_label_load() -> void:
	debug_label.text = "V (%.1f,%.1f) " % [velocity.x, velocity.y]


func _on_hurt_box_hit(damage: int, source: Node) -> void:
	print("Player hitted (%d) by %s" % [damage, source.name])
	# TODO: handle player being hit (death or hp reduction

func _on_animation_finished(anim_name: String) -> void:
	if anim_name in ["aim", "re_aim"]:
		finished_aiming = true
