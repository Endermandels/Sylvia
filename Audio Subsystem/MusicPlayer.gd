class_name MusicPlayer
extends Node

var currentTrack: String = ""
var isPlaying: bool = false
var audioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(audioStreamPlayer)

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
	#TODO: Implement this
	pass
	
#Helper function to convert linear volume to decibels
func linear2db(linear):
	#TODO: Implement this
	pass
