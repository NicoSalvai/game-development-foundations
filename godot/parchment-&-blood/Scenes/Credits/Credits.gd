class_name Credits
extends Control

@onready var content_group: CenterContainer = $CenterContainer
@onready var main_menu_button: CustomButton = $CenterContainer/VBoxContainer/MainMenuButton


func _ready() -> void:
	main_menu_button.callback = _on_main_menu_pressed
	content_group.modulate.a = 0.0
	await get_tree().create_timer(1.5).timeout
	var tween := create_tween()
	tween.tween_property(content_group, "modulate:a", 1.0, 0.8)


func _on_main_menu_pressed() -> void:
	GameManager.load_main_scene()
