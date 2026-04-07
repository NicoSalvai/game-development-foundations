extends Node

signal on_level_selected(level_setting: LevelSetting)
signal on_level_exited
signal on_tile_selected(tile: MemoryTile)
signal on_move_made
signal on_game_won(moves: int)

func emit_on_level_selected(level_setting: LevelSetting) -> void:
	on_level_selected.emit(level_setting)

func emit_on_level_exited() -> void:
	on_level_exited.emit()
	
func emit_on_tile_selected(tile: MemoryTile) -> void:
	on_tile_selected.emit(tile)

func emit_on_move_made() -> void:
	on_move_made.emit()

func emit_on_game_won(moves: int) -> void:
	on_game_won.emit(moves)
