class_name MainScreen
extends Control

const LEVEL_BUTTON = preload("uid://4xpe8sub8bsm")

@onready var h_box_container_levels: HBoxContainer = $VBoxContainer/HBoxContainerLevels

var level_settings: Array[LevelSetting] = [
	LevelSetting.new(2,2),
	LevelSetting.new(3,4),
	LevelSetting.new(4,4),
	LevelSetting.new(4,6),
	LevelSetting.new(5,6),
	LevelSetting.new(6,7)
]


func _ready() -> void:
	for level_setting in level_settings:
		var new_level_button: LevelButton = LEVEL_BUTTON.instantiate()
		new_level_button.level_setting = level_setting
		h_box_container_levels.add_child(new_level_button)
