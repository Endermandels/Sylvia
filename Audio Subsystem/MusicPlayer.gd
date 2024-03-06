class_name MusicPlayer
extends Node

var currentTrack: String = ""
var isPlaying: bool = false
var audioStreamPlayer = AudioStreamPlayer.new()
var totalVolume: float

func _ready():
	add_child(audioStreamPlayer)
	audioStreamPlayer.volume_db = -10

func play(track: String) -> void:
	currentTrack = track
	var stream = load(track) # Load the audio file
	if stream:
		audioStreamPlayer.stream = stream
		audioStreamPlayer.play()
		isPlaying = true

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
func linear2db(linear):
	if linear <= 0:
		return -80.0
	else:
		return 20.0 * log(linear) / log(10.0)
