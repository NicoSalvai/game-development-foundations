extends Control

@onready var continue_button: CustomButton = $MarginContainer/VBoxContainer/ContinueButton
@onready var new_game_button: CustomButton = $MarginContainer/VBoxContainer/NewGameButton
@onready var exit_button: CustomButton = $MarginContainer/VBoxContainer/ExitButton

func _ready() -> void:
	continue_button.callback = _on_continue
	new_game_button.callback = _on_new_game
	exit_button.callback = _on_exit


func _on_continue() -> void:
	pass


func _on_new_game() -> void:
	GameManager.load_level()


func _on_exit() -> void:
	get_tree().quit()
