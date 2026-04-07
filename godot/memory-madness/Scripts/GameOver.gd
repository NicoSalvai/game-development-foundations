class_name GameOver
extends PanelContainer

@onready var moves_label: Label = $VBoxContainer/MovesLabel

func _ready() -> void:
	SignalHub.on_game_won.connect(_on_game_won)

func _on_game_won(moves: int) -> void:
	show()
	moves_label.text = "Moves %d" % moves
