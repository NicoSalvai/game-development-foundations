class_name LevelButton


extends TextureButton


@export var level_number: int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel


func _ready() -> void:
	level_label.text = str(level_number)
	var score_number = ScoreManager.get_level_best(level_number)
	if score_number == 0:
		score_label.text = "----"
	else:
		score_label.text = "%04d" % score_number


func _on_mouse_entered() -> void:
	animation_player.play("enter_hover")


func _on_mouse_exited() -> void:
	animation_player.play("exit_hover")


func _on_pressed() -> void:
	ScoreManager.level_selected = level_number
	GameManager.load_level_scene(level_number)
