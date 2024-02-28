extends Node

var soundEffects: Dictionary = {}
var audioStreamPlayers: Dictionary = {}

func _ready():
	var effects = {
		"button" : "res://Sound Effects/Menu-Selection-Change-E.ogg", \
		"eating" : "res://Sound Effects/eating-sound-effect-36186.ogg", \
		"horn" : "res://Sound Effects/horn.ogg" \
	}

func play(effect: String) -> void:
	if soundEffects.has(effect):
		var player = audioStreamPlayers[effect]
		player.play()

func stop(effect: String) -> void:
	if soundEffects.has(effect):
		var player = audioStreamPlayers[effect]
		player.stop()

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
	#TODO: Implement this
	pass
	
#Helper function to convert linear volume to decibels
func linear2db(linear):
	#TODO: Implement this
	pass
