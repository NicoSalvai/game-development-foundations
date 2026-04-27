class_name CustomButtom
extends MarginContainer

@export var label: String = "Placeholder"
@export var disabled: bool = false

@onready var button_label: Label = $VBoxContainer/ButtonLabel

signal clicked

func _ready() -> void:
	button_label.text = label
	if disabled:
		disable()

func disable(flag: bool = true) -> void:
	disabled = flag
	if disabled:
		modulate = Color("c8c8c896")
	

func _on_gui_input(event: InputEvent) -> void:
	if not disabled and event.is_action_pressed("click"):
		clicked.emit()
