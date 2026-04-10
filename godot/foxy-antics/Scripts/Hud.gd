extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var h_box_hp: HBoxContainer = $MarginContainer/HBoxHP

@onready var game_over_panel: PanelContainer = $GameOverPanel
@onready var game_won_panel: PanelContainer = $GameWonPanel
@onready var game_over: AudioStreamPlayer = $GameOver
@onready var game_won: AudioStreamPlayer = $GameWon

var level_complete: bool = false

func _ready() -> void:
	game_over_panel.hide()
	game_won_panel.hide()
	SignalHub.on_points_scored.connect(_on_points_scored)
	SignalHub.on_lives_change.connect(_on_lives_change)
	SignalHub.on_game_over.connect(_on_game_over)
	SignalHub.on_level_completed.connect(_on_level_completed)
	_on_lives_change(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameManager.load_main_scene()
	if event.is_action_pressed("next") and level_complete:
		GameManager.load_next_level()


func _on_points_scored(points: int) -> void:
	GameManager.current_score += points
	score_label.text = "%03d" % GameManager.current_score

func _on_lives_change(_shake: bool) -> void:
	var hearths: Array[Node] = h_box_hp.get_children()
	for i in hearths.size():
		hearths[i].visible = i <= GameManager.current_lives -1

func _on_game_over() -> void:
	await get_tree().create_timer(0.4).timeout
	game_over.play()
	game_over_panel.show()
	get_tree().paused = true


func _on_level_completed() -> void:
	await get_tree().create_timer(0.4).timeout
	game_won.play()
	game_won_panel.show()
	get_tree().paused = true
	level_complete = true
