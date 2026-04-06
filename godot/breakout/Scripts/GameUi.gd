class_name GameUI
extends Control

@onready var score_label: Label = $MarginContainer/ScoreHB/ScoreLabel
@onready var win_label: Label = $MarginContainer/VBoxContainer/WinLabel
@onready var lost_label: Label = $MarginContainer/VBoxContainer2/LostLabel
@onready var lives_hb: HBoxContainer = $MarginContainer/LivesHB
@onready var timer: Timer = $Timer
@onready var press_space_label_win: Label = $MarginContainer/VBoxContainer/PressSpaceLabel
@onready var press_space_label_lost: Label = $MarginContainer/VBoxContainer2/PressSpaceLabel

const HEARTH = preload("uid://bk07tfw3b1pej")

func _ready() -> void:
	SignalHub.lives_updated.connect(_on_lives_updated)
	SignalHub.total_points_updated.connect(_on_total_points_updated)
	SignalHub.won_game.connect(_on_won_game)
	SignalHub.lost_game.connect(_on_lost_game)


func initialize(lives: int, score: int) -> void:
	update_lives(lives)
	update_score(score)

func _on_total_points_updated(score: int) -> void:
	update_score(score)


func update_score(score: int) -> void:
	score_label.text = "%04d" % score


func _on_lives_updated(lives: int):
	update_lives(lives)


func update_lives(lives: int) -> void:
	var hearths_diff = lives - (lives_hb.get_children().size() - 1)
	if hearths_diff > 0:
		for i in hearths_diff:
			lives_hb.add_child(HEARTH.instantiate())
	if hearths_diff < 0:
		for i in abs(hearths_diff):
			lives_hb.get_child(1).queue_free()


func _on_won_game() -> void:
	win_label.show()
	timer.timeout.connect(func(): press_space_label_win.show(), CONNECT_ONE_SHOT)
	timer.start()

func _on_lost_game() -> void:
	lost_label.show()
	timer.timeout.connect(func(): press_space_label_lost.show(), CONNECT_ONE_SHOT)
	timer.start()
