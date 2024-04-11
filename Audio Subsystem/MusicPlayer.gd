class_name MusicPlayer
extends Node

var currentTrack: String = ""
var isPlaying: bool = false
var audioStreamPlayer = AudioStreamPlayer.new()
var totalVolume: float
var musicIsFast: bool = false

func _ready():
	audioStreamPlayer.bus = "Music"
	add_child(audioStreamPlayer)
	audioStreamPlayer.volume_db = -11

func play(track: String) -> void:
	currentTrack = track
	var stream = load(track) # Load the audio file
	if stream:
		audioStreamPlayer.stream = stream
		audioStreamPlayer.play()
		isPlaying = true
	
func toggleFasterMusic() -> void:
	#I got this idea here: https://www.reddit.com/r/godot/comments/pkpcvn/speeding_up_music/
	var value = 1.1
	if musicIsFast:
		value = 1
	audioStreamPlayer.pitch_scale = value
	var music_bus_index = AudioServer.get_bus_index("Music")
	var pitch_effect = AudioServer.get_bus_effect(music_bus_index, 0)
	pitch_effect.pitch_scale = 1.0 / value
	musicIsFast = !musicIsFast

func fasterMusic() -> void:
	var value = 1.1
	audioStreamPlayer.pitch_scale = value
	var music_bus_index = AudioServer.get_bus_index("Music")
	var pitch_effect = AudioServer.get_bus_effect(music_bus_index, 0)
	pitch_effect.pitch_scale = 1.0 / value
	musicIsFast = true

func normalSpeedMusic() -> void:
	audioStreamPlayer.pitch_scale = 1.0
	var music_bus_index = AudioServer.get_bus_index("Music")
	var pitch_effect = AudioServer.get_bus_effect(music_bus_index, 0)
	pitch_effect.pitch_scale = 1.0
	musicIsFast = false

func stop() -> void:
	audioStreamPlayer.stop()
	isPlaying = false

func togglePause() -> void:
	if isPlaying:
		audioStreamPlayer.stop()
	else:
		audioStreamPlayer.play()
	isPlaying = !isPlaying

func set_volume(volume: float) -> void:
	totalVolume = linear2db(volume)
	audioStreamPlayer.volume_db = totalVolume
	
#Helper function to convert linear volume to decibels
#Credit: ChatGPT
func linear2db(linear):
	if linear <= 0:
		return -80.0
	else:
		return 20.0 * log(linear) / log(10.0)
