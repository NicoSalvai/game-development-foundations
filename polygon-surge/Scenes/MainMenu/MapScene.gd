class_name MapScene
extends Control

const LEVEL_LABELS: Dictionary[int, String] = {
	1: "Nivel 1",
	2: "Nivel 2",
	3: "Nivel 3",
	4: "Nivel 4",
	5: "Nivel 5 — Boss",
}
const CUSTOM_BUTTON = preload("uid://cuq8ugq2we67o")

@onready var level_list: VBoxContainer = $MarginContainer/VBoxContainer/LevelList


func _ready() -> void:
	_build_level_list()


func _build_level_list() -> void:
	for child in level_list.get_children():
		child.queue_free()

	for level_id in LEVEL_LABELS.keys():
		var status: GameState.LevelStatus = GameState.get_status(level_id)
		var button: CustomButtom = CUSTOM_BUTTON.instantiate()
		var label: String = LEVEL_LABELS[level_id]

		match status:
			GameState.LevelStatus.LOCKED:
				button.label = "🔒 %s" % label
				button.disabled = true
			GameState.LevelStatus.AVAILABLE:
				button.label = label
			GameState.LevelStatus.COMPLETED:
				button.label = "✓ %s" % label

		button.clicked.connect(_on_level_pressed.bind(level_id))
		level_list.add_child(button)


func _on_level_pressed(level_id: int) -> void:
	GameManager.load_level_scene(level_id)


func _on_back_pressed() -> void:
	GameManager.load_main_scene()
