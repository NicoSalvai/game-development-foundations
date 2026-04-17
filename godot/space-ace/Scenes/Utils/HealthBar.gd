class_name HealthBar
extends TextureProgressBar

signal died

const COLOR_DANGER: Color = Color.RED
const COLOR_MID: Color = Color.ORANGE
const COLOR_GOOD: Color = Color.GREEN


@export var low_level: int  = 30
@export var mid_level: int  = 65
@export var start_hp: int  = 100
@export var max_hp: int = 100

var _dead: bool = false


func _ready() -> void:
	max_value = max_hp
	value = start_hp
	set_color()


func set_color() -> void:
	if value < low_level:
		tint_progress = COLOR_DANGER
	elif value < mid_level:
		tint_progress = COLOR_MID
	else:
		tint_progress = COLOR_GOOD


func increment_value(v: int) -> void:
	value += v
	if value <= 0 and !_dead:
		_dead = true
		died.emit()
	set_color()


func take_damage(damage: int) -> void:
	increment_value(-damage)
