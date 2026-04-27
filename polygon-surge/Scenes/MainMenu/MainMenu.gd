class_name MainMenuScene
extends Control

@onready var continue_button: CustomButtom = $MarginContainer/VBoxContainer/ContinueButton
@onready var new_game_button: CustomButtom = $MarginContainer/VBoxContainer/NewGameButton
@onready var exit_button: CustomButtom = $MarginContainer/VBoxContainer/ExitButton


func _ready() -> void:
	continue_button.disable(not GameState.has_progress())


func _on_new_game_pressed() -> void:
	GameState.reset()
	GameManager.load_map_scene()


func _on_continue_pressed() -> void:
	GameManager.load_map_scene()


func _on_exit_pressed() -> void:
	get_tree().quit()
