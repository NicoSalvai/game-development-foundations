class_name Main
extends Control

@onready var new_game: CustomMenuButton = $MarginContainer/VBoxContainer/MarginContainer/Menu/NewGame
@onready var level_select: CustomMenuButton = $MarginContainer/VBoxContainer/MarginContainer/Menu/LevelSelect
@onready var exit: CustomMenuButton = $MarginContainer/VBoxContainer/MarginContainer/Menu/Exit
@onready var back_button: CustomMenuButton = $MarginContainer/VBoxContainer/MarginContainer/LevelMenu/VBoxContainer/BackButton

@onready var menu: VBoxContainer = $MarginContainer/VBoxContainer/MarginContainer/Menu
@onready var level_menu: MarginContainer = $MarginContainer/VBoxContainer/MarginContainer/LevelMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game.function = _new_game
	level_select.function = _level_select
	exit.function = _exit
	back_button.function = _back_button


func _new_game() -> void:
	GameManager.selected_level = 1
	GameManager.load_level_scene()


func _level_select() -> void:
	menu.hide()
	level_menu.show()


func _exit() -> void:
	get_tree().quit()


func _back_button() -> void:
	menu.show()
	level_menu.hide()
