class_name CustomButton
extends PanelContainer

@onready var label: Label = $MarginContainer/Label
@onready var hover_texture: NinePatchRect = $HoverTexture
@onready var normal_texture: NinePatchRect = $NormalTexture
@onready var panel_container: CustomButton = $"."

@export var text: String = "Placeholder"
@export var disabled: bool = false
var callback: Callable

func _ready() -> void:
	label.text = text
	if disabled:
		normal_texture.show()
		panel_container.modulate = Color8(87, 87, 87, 235)


func _on_button_mouse_entered() -> void:
	if !disabled:
		hover_texture.show()
		normal_texture.hide()


func _on_button_mouse_exited() -> void:
	if !disabled:
		hover_texture.hide()
		normal_texture.show()


func _on_button_pressed() -> void:
	if !disabled:
		callback.call()
