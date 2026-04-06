class_name LevelButton
extends TextureButton

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $MarginContainer/Label

@export var level: int = 0
@export var high_score: int = 0

func _ready() -> void:
	label.text = "%02d" % level


func _on_pressed() -> void:
	GameManager.selected_level = level
	GameManager.load_level_scene()


func _on_mouse_entered() -> void:
	animation_player.play("hover_")


func _on_mouse_exited() -> void:
	animation_player.play("hover_stop")
