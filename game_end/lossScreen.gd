extends Control

@onready var audio_manager = $AudioManager

func _on_ready():

	theme = load(Settings.theme)
	set_theme(theme)
	get_theme().default_font_size = Settings.font_size

func _on_start_pressed():
	audio_manager.playSFX("button")
	get_tree().change_scene_to_file("res://start_menu/start_menu.tscn")

func _on_exit_pressed():
	audio_manager.playSFX("button")
	get_tree().quit()

