extends Control


class_name GameUi


signal start_match

@onready var player_1_score: Label = $MarginContainer/Player1Score
@onready var player_2_score: Label = $MarginContainer/Player2Score
@onready var winner_label: Label = $MarginContainer/VBoxContainer/WinnerLabel
@onready var press_space_to_start_label: Label = $MarginContainer/VBoxContainer/PressSpaceToStartLabel
@onready var point_for_label: Label = $MarginContainer/VBoxContainer/PointForLabel
@onready var timer: Timer = $Timer


var player_scores: Dictionary = {
	1: 0,
	2: 0
}


var score_goal: int


func _ready() -> void:
	SignalBusI.point_scored.connect(_on_point_scored)
	_update_label(player_1_score, 0)
	_update_label(player_2_score, 0)


func _on_point_scored(scoring_player_id: int) -> void:
	_update_score(scoring_player_id)
	_update_point_for_label(scoring_player_id)
	if player_scores[scoring_player_id] < score_goal:
		timer.timeout.connect(_show_press_space_to_start_label, ConnectFlags.CONNECT_ONE_SHOT)
	else:
		winner_label.text = "Winner is Player %d! \n Press Space to go back." % scoring_player_id
		timer.timeout.connect(_show_winner_label, ConnectFlags.CONNECT_ONE_SHOT)
	timer.start()


func _show_press_space_to_start_label() -> void:
	press_space_to_start_label.show()


func _show_winner_label() -> void:
	point_for_label.hide()
	winner_label.show()


func _update_point_for_label(id: int) -> void:
	point_for_label.text = "Point For Player %d" % id
	point_for_label.show()


func _update_score(id: int) -> void:
	player_scores[id] += 1
	match id:
		1: _update_label(player_1_score, player_scores[id])
		2: _update_label(player_2_score, player_scores[id])


func _update_label(label: Label, value: int) -> void:
	label.text = "%02d" % value


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and press_space_to_start_label.visible:
		press_space_to_start_label.hide()
		point_for_label.hide()
		start_match.emit()
	elif event.is_action_pressed("ui_accept") and winner_label.visible:
		winner_label.hide()
		get_tree().reload_current_scene()
