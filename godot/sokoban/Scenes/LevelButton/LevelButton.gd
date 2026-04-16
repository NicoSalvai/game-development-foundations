class_name LevelButton
extends NinePatchRect

@onready var checkmark: TextureRect = $MarginContainer/Checkmark
@onready var level_label: Label = $LevelLabel

@export var text: String = ""
@export var checked: bool = false

func setup(_text: String, _checked: bool = false) -> void:
	text = _text
	checked = _checked

func _ready() -> void:
	level_label.text = text
	checkmark.visible = checked


func _on_margin_container_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		GameManager.set_level(text)
