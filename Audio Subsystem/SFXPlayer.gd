class_name SFXPlayer
extends Node

var soundEffects: Dictionary = {}
var audioStreamPlayers: Dictionary = {}
var recentlyPlayedEffects: Array = []
var totalVolume: float
var isPlaying: bool = false

func _ready():
	var effects = { \
		"button" : "res://Sound Effects/Menu-Selection-Change-E.ogg", \
		"horn" : "res://Sound Effects/horn.ogg", \
		"eating" : "res://Sound Effects/eating-sound-effect-36186.ogg", \
	}
	loadEffects(effects)
	audioStreamPlayers["horn"].volume_db = -12
	audioStreamPlayers["button"].volume_db = -12
	audioStreamPlayers["eating"].volume_db = -12

func play(effect: String) -> void:
	if soundEffects.has(effect):
		var player = audioStreamPlayers[effect]
		player.play()
		recentlyPlayedEffects.append(effect)
		isPlaying = true

func stop(effect: String) -> void:
	if soundEffects.has(effect):
		var player = audioStreamPlayers[effect]
		player.stop()
		isPlaying = false

func loadEffects(effects: Dictionary) -> void:
	for effect in effects.keys():
		var stream = load(effects[effect])
		if stream:
			var player = AudioStreamPlayer.new()
			player.stream = stream
			add_child(player)
			soundEffects[effect] = stream
			audioStreamPlayers[effect] = player
		else:
			print("Failed to load effect: " + effects[effect])
		
		
func set_volume(volume: float) -> void:
	totalVolume = linear2db(volume)
	for player in audioStreamPlayers.values():
		player.volume_db = totalVolume
	
#Helper function to convert linear volume to decibels
func linear2db(linear):
	if linear <= 0:
		return -80.0
	else:
		return 20.0 * log(linear) / log(10.0)
