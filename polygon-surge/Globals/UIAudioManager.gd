extends Node

@export var hover_sfx: AudioStream
@export var click_sfx: AudioStream
@export var ui_music: AudioStream

var _music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var _hover_player: AudioStreamPlayer = AudioStreamPlayer.new()
var _click_player: AudioStreamPlayer = AudioStreamPlayer.new()

const CLICK: AudioStream = preload("uid://xnhbqqnh4v51")
const HOVER: AudioStream = preload("uid://b3v033iwunboj")

const MUSIC_INTRO: AudioStream = preload("uid://c3g3qkavm8fdl")
const MUSIC_LOOP: AudioStream = preload("uid://5s734kghw6ic")


func _ready() -> void:
	_hover_player.stream = HOVER
	_click_player.stream = CLICK
	_music_player.volume_db = -10.0

	add_child(_music_player)
	add_child(_hover_player)
	add_child(_click_player)


func play_hover() -> void:
	_hover_player.play()


func play_click() -> void:
	_click_player.play()


func play_ui_music() -> void:
	if _music_player.playing:
		return
	_music_player.play()


func stop_ui_music() -> void:
	_music_player.stop()

func set_music(music: AudioStream) -> void:
	if _music_player.playing:
		return
	_music_player.stream = music
	play_ui_music()
