extends Control

class_name GameUI

@onready var game_over_label: Label = $MarginContainer/GameOverLabel
@onready var sound: AudioStreamPlayer = $Sound
@onready var press_space_label_timer: Timer = $PressSpaceLabelTimer
@onready var press_space_label: Label = $MarginContainer/PressSpaceLabel
@onready var score_label: Label = $MarginContainer/ScoreLabel

var score: int = 0
func _ready() -> void:
	SignalBus.tappy_plane_died.connect(on_tappy_plane_died)
	SignalBus.point_scored.connect(on_point_scored)
	press_space_label_timer.timeout.connect(enable_press_space_to_go_back)
	update_score_label()


func on_point_scored() -> void:
	score += 1
	update_score_label()


func update_score_label() -> void:
	score_label.text = "%03d" % score


func on_tappy_plane_died() -> void:
	game_over_label.show()
	sound.play()
	press_space_label_timer.start()
	ScoreManager.high_score = score


func enable_press_space_to_go_back() -> void:
	press_space_label.show()
	game_over_label.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameManager.load_main_scene()
	if event.is_action_pressed("ui_accept") and press_space_label.visible:
		press_space_label.hide()
		GameManager.load_main_scene()
