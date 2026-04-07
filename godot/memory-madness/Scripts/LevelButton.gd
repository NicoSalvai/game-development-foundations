class_name LevelButton
extends TextureButton

@export var level_setting: LevelSetting
@onready var label: Label = $Label

func _ready() -> void:
	label.text = "%s" % level_setting


func _on_pressed() -> void:
	SignalHub.emit_on_level_selected(level_setting)
