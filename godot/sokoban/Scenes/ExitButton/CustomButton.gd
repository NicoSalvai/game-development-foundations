class_name CustomButton
extends NinePatchRect

@onready var label: Label = $MarginContainer/Label

@export var text: String = ""
var function: Callable

func _ready() -> void:
	label.text = text

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		function.call()
