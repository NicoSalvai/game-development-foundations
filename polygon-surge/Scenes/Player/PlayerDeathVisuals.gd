class_name PlayerDeathVisuals
extends Node

const VIBRATION_STRENGTH  := 4.0
const VIBRATION_DURATION  := 1.3
const VIBRATION_STEPS     := 8
const EXPLOSION_STRENGTH  := 60.0
const EXPLOSION_DURATION  := 0.8
const FADE_DURATION       := 0.35
const CORE_GLOW_MAX       := 6.0

@onready var visuals: Node2D    = $".."
@onready var core: Polygon2D    = $"../CoreStruct/Core"

const FRAGMENTS: Array[String] = [
	"CoreStruct",
	"TopArmor",
	"TopArmor2",
	"Outside",
	"Outside2",
	"ArmorBack",
	"ArmorBack2",
]


func play_death(on_complete: Callable) -> void:
	_vibrate(func(): _explode(on_complete))


func _vibrate(on_complete: Callable) -> void:
	var origin := visuals.position
	
	var glow_tween := create_tween()
	glow_tween.set_trans(Tween.TRANS_EXPO)
	glow_tween.set_ease(Tween.EASE_IN)
	glow_tween.tween_property(core, "modulate",
		Color(CORE_GLOW_MAX, CORE_GLOW_MAX, CORE_GLOW_MAX, 1.0),
		VIBRATION_DURATION
	)

	var vib_tween := create_tween()
	for i in VIBRATION_STEPS:
		var offset := Vector2(
			randf_range(-VIBRATION_STRENGTH, VIBRATION_STRENGTH),
			randf_range(-VIBRATION_STRENGTH, VIBRATION_STRENGTH)
		)
		vib_tween.tween_property(visuals, "position", origin + offset, VIBRATION_DURATION / VIBRATION_STEPS)
	vib_tween.tween_property(visuals, "position", origin, 0.05)
	vib_tween.tween_callback(on_complete)


func _explode(on_complete: Callable) -> void:
	var tween          := create_tween()
	var fragment_count := FRAGMENTS.size()
	tween.set_parallel(true)

	for i in fragment_count:
		var fragment: Node2D = visuals.get_node(FRAGMENTS[i])
		var angle            := (2.0 * PI / fragment_count) * i
		var direction        := Vector2(cos(angle), sin(angle))
		var target_pos       := fragment.position + direction * EXPLOSION_STRENGTH

		tween.tween_property(fragment, "position", target_pos, EXPLOSION_DURATION)\
			.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property(fragment, "modulate:a", 0.0, FADE_DURATION)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.chain().tween_callback(on_complete)
