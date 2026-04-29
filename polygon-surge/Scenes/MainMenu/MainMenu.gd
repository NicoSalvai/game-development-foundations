class_name MainMenuScene
extends Control



@onready var continue_button: CustomButtom = $MarginContainer/VBoxContainer/ContinueButton
@onready var new_game_button: CustomButtom = $MarginContainer/VBoxContainer/NewGameButton
@onready var exit_button: CustomButtom = $MarginContainer/VBoxContainer/ExitButton
@onready var music_config: AudioStreamPlayer = $MusicConfig


func _ready() -> void:
	GameManager.set_cursor()
	continue_button.disable(not SaveManager.has_save())
	UIAudioManager.set_music(music_config.stream)



func _on_new_game_pressed() -> void:
	GameState.reset()
	GameManager.load_map_scene()


func _on_continue_pressed() -> void:
	GameManager.load_map_scene()


func _on_exit_pressed() -> void:
	get_tree().quit()
