extends GutTest

var audio_manager
var musicPlayer
var sfxPlayer

#This is not a test. It is only to set up the environment for the tests that follow.
func before_all():
	var a_manager = preload("res://Audio Subsystem/AudioManager.gd")
	audio_manager = a_manager.new()
	add_child(audio_manager)
	var m_player = preload("res://Audio Subsystem/MusicPlayer.gd")
	musicPlayer = m_player.new()
	add_child(musicPlayer)
	var sfx_player = preload("res://Audio Subsystem/SFXPlayer.gd")
	sfxPlayer = sfx_player.new()
	add_child(sfxPlayer)
	audio_manager.musicPlayer = musicPlayer
	audio_manager.sfxPlayer = sfxPlayer

#acceptance test
func test_music_playing():
	musicPlayer.play("res://Music/battle_music (surf).ogg")
	assert_eq(musicPlayer.currentTrack, "res://Music/battle_music (surf).ogg")
	assert_true(musicPlayer.isPlaying)

#acceptance test
func test_stop_music():
	musicPlayer.play("res://Music/retro_funk.ogg")
	musicPlayer.stop()
	assert_false(musicPlayer.isPlaying)

#acceptance test
func test_toggle_pause_music():
	musicPlayer.play("res://Music/retro_funk.ogg")
	musicPlayer.togglePause()
	assert_false(musicPlayer.isPlaying)
	musicPlayer.togglePause()
	assert_true(musicPlayer.isPlaying)

#acceptance test
func test_set_music_volume():
	musicPlayer.set_volume(0.5)
	assert_eq(musicPlayer.totalVolume, 0.5)

#acceptance test
func test_linear2db_music():
	assert_eq(musicPlayer.linear2db(0), -80)
	assert_eq(musicPlayer.linear2db(1.0), 0)

	var known_value_db = 20 * log(0.5) / log(10.0)  # Calculate expected dB for volume of 0.5
	assert_eq(musicPlayer.linear2db(0.5), known_value_db)

	assert_true(musicPlayer.linear2db(0.0001) > -80)
	assert_true(musicPlayer.linear2db(0.9999) < 0)

#acceptance test
func test_linear2db_sfx():
	assert_eq(sfxPlayer.linear2db(0), -80)
	assert_eq(sfxPlayer.linear2db(1.0), 0)

	var known_value_db = 20 * log(0.5) / log(10.0)  # Calculate expected dB for volume of 0.5
	assert_eq(sfxPlayer.linear2db(0.5), known_value_db)

	assert_true(sfxPlayer.linear2db(0.0001) > -80)
	assert_true(sfxPlayer.linear2db(0.9999) < 0)

#acceptance test
func test_play_sfx():
	sfxPlayer.play("horn")
	assert_true(sfxPlayer.isPlaying)
	
#acceptance test
func test_stop_sfx():
	sfxPlayer.play("horn")
	sfxPlayer.stop("horn")
	assert_false(sfxPlayer.isPlaying)


#This is a white box test. 
#100% statement coverage.
#Here is the function that it is testing:
#func loadEffects(effects: Dictionary) -> void:
	#for effect in effects.keys():
		#var stream = load(effects[effect])
		#if stream:
			#var player = AudioStreamPlayer.new()
			#player.stream = stream
			#add_child(player)
			#soundEffects[effect] = stream
			#audioStreamPlayers[effect] = player
		#else:
			#print("Failed to load effect: " + effects[effect])
func test_load_sfx():
	var effects = { \
		"button" : "res://Sound Effects/Menu-Selection-Change-E.ogg", \
		"horn" : "res://Sound Effects/horn.ogg", \
		"shouldFail" : "shouldFail directory", \
	}
	sfxPlayer.loadEffects(effects)
	assert_true("button" in sfxPlayer.soundEffects)
	assert_false("shouldFail" in sfxPlayer.soundEffects)

#acceptance test
func test_set_sfx_volume():
	sfxPlayer.set_volume(0.5)
	assert_eq(sfxPlayer.totalVolume, 0.5)

#acceptance test
func test_get_volume_audio_manager():
	audio_manager.setVolume(0.6)
	assert_eq(audio_manager.getVolume(), 0.6)

#This is an integration test because it is testing if the audio manager
#class successfully changes the volume of the music player and sfx player classes.
#My approach was a big-bang approach because I implemented them all then then tested them
#together afterwards.
func test_set_volume_audio_manager():
	audio_manager.setVolume(0.7)
	assert_eq(sfxPlayer.totalVolume, 0.7)
	assert_eq(musicPlayer.totalVolume, 0.7)
