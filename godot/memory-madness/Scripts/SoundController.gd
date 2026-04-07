extends Node

@export var main_menu_music: AudioStream
@export var game_music: AudioStream
@export var click_effect: AudioStream
@export var tile_effect: AudioStream
@export var game_over_effect: AudioStream

@onready var music: AudioStreamPlayer = $Music
@onready var effect: AudioStreamPlayer = $Effect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.on_level_selected.connect(_on_level_selected)
	SignalHub.on_level_exited.connect(_on_level_exited)
	SignalHub.on_tile_selected.connect(_on_tile_selected)
	SignalHub.on_game_won.connect(_on_game_won)
	play_music(main_menu_music)


func play_music(stream: AudioStream) -> void:
	music.stream = stream
	music.play()


func play_effect(stream: AudioStream) -> void:
	effect.stream = stream
	effect.play()


func _on_level_selected(_level_setting: LevelSetting) -> void:
	play_music(game_music)
	play_effect(click_effect)


func _on_level_exited() -> void:
	play_music(main_menu_music)


func _on_tile_selected(_tile: MemoryTile) -> void:
	play_effect(tile_effect)


func _on_game_won(_moves: int) -> void:
	play_effect(game_over_effect)
