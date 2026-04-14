extends Control


@onready var continue_button: CustomButton = $PausePanel/MarginContainer/VBoxContainer/ContinueButton
@onready var exit_button: CustomButton = $PausePanel/MarginContainer/VBoxContainer/ExitButton

@onready var next_level_button: CustomButton = $WinPanel/MarginContainer/VBoxContainer/HBoxContainer/NextLevelButton
@onready var exit_button2: CustomButton = $WinPanel/MarginContainer/VBoxContainer/HBoxContainer/ExitButton

@onready var restart_level_button: CustomButton = $GameOverPanel/MarginContainer/VBoxContainer/HBoxContainer/RestartLevelButton
@onready var exit_button3: CustomButton = $GameOverPanel/MarginContainer/VBoxContainer/HBoxContainer/ExitButton

@onready var backdrop: Panel = $Backdrop
@onready var pause_panel: PanelContainer = $PausePanel
@onready var win_panel: PanelContainer = $WinPanel
@onready var game_over_panel: PanelContainer = $GameOverPanel

var paused: bool = false

func _ready() -> void:
	continue_button.callback = _on_continue
	next_level_button.callback = _on_next_level
	restart_level_button.callback = _on_restart_level
	exit_button.callback = _on_exit
	exit_button2.callback = _on_exit
	exit_button3.callback = _on_exit
	SignalHub.on_level_ended.connect(_on_level_ended)
	SignalHub.on_player_die.connect(_on_player_die)
	SignalHub.on_wave_completed.connect(_on_wave_completed)

func _on_continue() -> void:
	on_pause(false)


func _on_exit() -> void:
	GameManager.load_main_scene()

func _on_next_level() -> void:
	GameManager.load_next_level()

func _on_restart_level() -> void:
	GameManager.load_level()

func _on_wave_completed() -> void:
	print("Wave completed")
	pass
	# TODO show some simple message for a couple of seconds letting the player know that he cleared a wave

func on_pause(pause: bool = true) -> void:
	get_tree().paused = pause
	backdrop.visible = pause
	pause_panel.visible = pause
	paused = pause


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and !paused:
		on_pause(!paused)
	
func _on_level_ended() -> void:
	get_tree().paused = true
	backdrop.visible = true
	win_panel.visible = true
	paused = true

func _on_player_die() -> void:
	get_tree().paused = true
	backdrop.visible = true
	game_over_panel.visible = true
	paused = true
