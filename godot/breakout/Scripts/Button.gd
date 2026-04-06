class_name CustomMenuButton
extends TextureButton

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $MarginContainer/Label
@export var label_text = ""
var function: Callable

func _ready() -> void:
	label.text = label_text


func _on_pressed() -> void:
	if function:
		function.call()


func _on_mouse_entered() -> void:
	animation_player.play("hover_")


func _on_mouse_exited() -> void:
	animation_player.play("hover_stop")
