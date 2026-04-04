class_name GameUI

extends Control

@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var attempts_label: Label = $MarginContainer/VBoxContainer/AttemptsLabel
@onready var level_complete_label: Label = $MarginContainer/VBoxContainer2/LevelCompleteLabel
@onready var press_escape_label: Label = $MarginContainer/VBoxContainer2/PressEscapeLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	SignalHub.on_level_completed.connect(_on_level_completed)
	SignalHub.on_attempts_updated.connect(_on_attempts_updated)


func _on_level_completed() -> void:
	level_complete_label.show()
	press_escape_label.show()
	audio_stream_player.play()
	get_tree().paused = true


func _on_attempts_updated(attempts: int) -> void:
	attempts_label.text = "Attempts %02d" % attempts


func set_level(level: int) -> void:
	level_label.text = "Level %d" % level


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and press_escape_label.visible:
		get_tree().paused = false
		GameManager.load_main_scene()
		
