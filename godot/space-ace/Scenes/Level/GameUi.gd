class_name GameUI
extends Control

@onready var health_bar: HealthBar = $MarginContainer/HealthBar
@onready var label: Label = $MarginContainer/Label
@onready var boost: AudioStreamPlayer = $Boost

var score: int = 0
 
func _ready() -> void:
	SignalHub.player_received_damage.connect(_on_player_received_damage)
	SignalHub.points_scored.connect(_on_points_scored)
	SignalHub.player_health_boost.connect(_on_player_health_boost)
	health_bar.died.connect(_on_player_died)
	label.text = "%04d" % score


func _on_player_received_damage(damage: int) -> void:
	health_bar.take_damage(damage)

func _on_player_health_boost(heal: int) -> void:
	health_bar.increment_value(heal)
	boost.play()

func _on_player_died() -> void:
	get_tree().paused = true

func _on_points_scored(points: int) -> void:
	score += points
	label.text = "%04d" % score
