extends Node

var globalVolume: float = 1.0
var musicPlayer
var sfxPlayer
var uiAudioPlayer


func _ready():
	musicPlayer = $MusicPlayer
	sfxPlayer = $SFXPlayer
	uiAudioPlayer = $UIAudioPlayer
	#TODO: Set up initial volumes or any other initialization needed

func playMusic(track: String) -> void:
	musicPlayer.play(track)
	
func stopMusic() -> void:
	musicPlayer.stop()
	
func playSFX(effect: String) -> void:
	sfxPlayer.play(effect)
	
func playUIEffect(effect: String) -> void:
	uiAudioPlayer.play(effect)

func setVolume(volume: float) -> void:
	globalVolume = volume
	musicPlayer.set_volume(volume)
	sfxPlayer.set_volume(volume)
	uiAudioPlayer.set_volume(volume)
	
func getVolume() -> float:
	return globalVolume
