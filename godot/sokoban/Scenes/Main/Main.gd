class_name Main
extends Control

const LEVEL_BUTTON = preload("uid://de5mer8j0p27v")

@onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/GridContainer

func _ready() -> void:
	for level in LevelData.all_level_data:
		var lb: LevelButton = LEVEL_BUTTON.instantiate()
		lb.setup(level, false)
		grid_container.add_child(lb)
