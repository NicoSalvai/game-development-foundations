class_name Game
extends Control

const MEMORY_TILE = preload("uid://twsnf4q45v13")

@onready var grid_container: GridContainer = $MarginContainer/GridContainer
@onready var label_moves: Label = $MarginContainer/VB/HBMoves/LabelMoves
@onready var label_pairs: Label = $MarginContainer/VB/HBPairs/LabelPairs
@onready var scorer: Scorer = $Scorer
@onready var game_over: PanelContainer = $MarginContainer2/GameOver

func _ready() -> void:
	SignalHub.on_level_selected.connect(_on_level_selected)
	SignalHub.on_move_made.connect(_on_move_made)


func _on_exit_button_pressed() -> void:
	update_moves()
	update_pairs()
	for child in grid_container.get_children():
		child.queue_free()
	SignalHub.emit_on_level_exited()


func _on_level_selected(level_setting: LevelSetting) -> void:
	game_over.hide()
	scorer.setup(level_setting)
	update_moves()
	update_pairs(level_setting.target_pairs)
	
	var lds: LevelDataSelector = LevelDataSelector.new()
	var selected_images: Array[Texture2D] = lds.get_images_for_level(level_setting)
	var frame = ImageManager.get_random_frame_image()
	
	grid_container.columns = level_setting.cols
	for num in range(level_setting.total_tiles):
		var empty: MemoryTile = MEMORY_TILE.instantiate()
		grid_container.add_child(empty)
		empty.setup(selected_images[num], frame)


func update_moves() -> void:
	label_moves.text = "%d" % scorer.moves_made

func update_pairs(_total_pairs: int = 0, _pairs: int = 0) -> void:
	label_pairs.text = "%d/%d" % [scorer.pairs_made, scorer.target_pairs]

func _on_move_made() -> void:
	update_moves()
	update_pairs()
