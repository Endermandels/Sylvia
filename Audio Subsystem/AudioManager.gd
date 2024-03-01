class_name AudioManager
extends Node

var globalVolume: float = 1.0
var musicPlayer
var sfxPlayer


func _ready():
	musicPlayer = $MusicPlayer
	sfxPlayer = $SFXPlayer
	#TODO: Set up initial volumes or any other initialization needed

func playMusic(track: String) -> void:
	musicPlayer.play(track)
	
func stopMusic() -> void:
	musicPlayer.stop()
	
func playSFX(effect: String) -> void:
	sfxPlayer.play(effect)
	
func setVolume(volume: float) -> void:
	globalVolume = volume
	musicPlayer.set_volume(volume)
	sfxPlayer.set_volume(volume)
	
func getVolume() -> float:
	return globalVolume
