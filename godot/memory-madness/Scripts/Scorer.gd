class_name Scorer
extends Node

static var SelectionEnabled: bool = true
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var reveal_timer: Timer = $RevealTimer
var _selections: Array[MemoryTile] = []
var target_pairs: int = 0
var moves_made: int = 0
var pairs_made: int = 0


func _ready() -> void:
	SignalHub.on_level_exited.connect(_on_level_exited)
	SignalHub.on_tile_selected.connect(_on_tile_selected)
	reveal_timer.timeout.connect(_on_reveal_timer_timeout)


func setup(level_setting: LevelSetting) -> void:
	target_pairs = level_setting.target_pairs
	moves_made = 0
	pairs_made = 0
	_selections.clear()


func _on_tile_selected(tile: MemoryTile) -> void:
	if !SelectionEnabled or tile in _selections:
		return
		
	_selections.append(tile)
	
	process_pair()


func process_pair() -> void:
	if _selections.size() != 2:
		return
	moves_made += 1
	prevent_selections()
	reveal_timer.start()
	
	if _selections[0].matches(_selections[1]):
		pairs_made += 1
		_selections.map(func(item: MemoryTile): item.kill())
		audio_stream_player.play()
	
	SignalHub.emit_on_move_made()
	if pairs_made == target_pairs:
		SignalHub.emit_on_game_won(moves_made)


func prevent_selections(flag: bool = true) -> void:
	SelectionEnabled = !flag


func _on_reveal_timer_timeout() -> void:
	_selections.map(func(selection: MemoryTile): selection.reveal(false))
	_selections.clear()
	prevent_selections(false)


func _on_level_exited() -> void:
	prevent_selections(false)
	reveal_timer.stop()
	_selections.clear()
