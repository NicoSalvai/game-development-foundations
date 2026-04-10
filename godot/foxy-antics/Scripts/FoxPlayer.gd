class_name FoxPlayer
extends CharacterBody2D

const SPEED: float = 120.0
const JUMP_VELOCITY: float = -270.0
const HURT_VELOCITY: Vector2 = Vector2(65.0, -130.0)

@onready var player_cam: Camera2D = $PlayerCam
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var controller: Node = $PlayerController
@onready var debug_label: Label = $DebugLabel
@onready var shooter: Shooter = $Shooter
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var sound_hurt: AudioStreamPlayer2D = $SoundHurt
@onready var hurt_timer: Timer = $HurtTimer


var _coyote_time: float = 0.0
var _is_hurt: bool = false
var _is_invincible: bool = false

func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP_NAME)
	SignalHub.on_game_over.connect(_on_game_over)


func _physics_process(delta: float) -> void:
	update_debug_label()
	fallen_off_map()
	handle_gravity(delta)
	if !_is_hurt:
		handle_jump(delta)
		handle_movement()
	move_and_slide()


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = min(velocity.y + get_gravity().y * delta, Constants.MAX_FALL_SPEED)


func handle_jump(delta: float) -> void:
	if is_on_floor():
		_coyote_time = 0.0
		trigger_jump()
	elif is_on_coyote_time(): 
		_coyote_time += delta
		trigger_jump()
	else:
		controller.jumped()


func trigger_jump() -> void:
	if controller.jump:
		sound.play()
		velocity.y = JUMP_VELOCITY
		controller.jumped()
		_coyote_time = 1.0


func is_on_coyote_time() -> bool:
	return _coyote_time <= 0.1


func handle_movement() -> void:
	if controller.direction:
		velocity.x = controller.direction * SPEED
		sprite_2d.flip_h = true if velocity.x < 0 else false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func fallen_off_map() -> void:
	if global_position.y > Constants.Y_LIMIT:
		apply_hit(0.0, GameManager.current_lives)


func update_debug_label() -> void:
	debug_label.text = ""
	debug_label.text += "V (%s) D (%s)" % [velocity, controller.direction]
	debug_label.text += "H (%s) I (%s)" % [_is_hurt, _is_invincible]
	debug_label.text += "\nP (%s)" % [global_position]
	debug_label.text += "\nF (%s) J (%s) CT (%s)" % [
		is_on_floor(), controller.jump, is_on_coyote_time()]

func shoot() -> void:
	shooter.shoot(Vector2.LEFT if sprite_2d.flip_h else Vector2.RIGHT)


func _on_hit_box_area_entered(area: Area2D) -> void:
	var x_dir: float = sign(global_position.direction_to(area.global_position).x)
	call_deferred("apply_hit", x_dir, 1)


func apply_hit(x_dir: float, damage: int) -> void:
	if _is_invincible:
		return
	GameManager.current_lives -= damage
	apply_hurt_jump(x_dir)


func apply_hurt_jump(x_dir: float) -> void:
	_is_hurt = true
	go_invicible()
	velocity = HURT_VELOCITY * Vector2(-x_dir, 1.0)
	sound_hurt.play()
	hurt_timer.start()

func go_invicible() -> void:
	if _is_invincible:
		return
	_is_invincible = true
	
	var sub_tween = create_tween()
	sub_tween.set_loops(7)
	sub_tween.tween_property(sprite_2d, "modulate", Color.TRANSPARENT, 0.1)
	sub_tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.1)
	
	var tween: Tween = create_tween()
	tween.tween_subtween(sub_tween)
	tween.tween_callback(func(): _is_invincible = false)
	

func _on_hurt_timer_timeout() -> void:
	_is_hurt = false
	
func _on_game_over() -> void:
	set_physics_process(false)
