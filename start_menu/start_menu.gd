extends Control


#Apply current theme settings to root
func _on_ready():
	AudioManager.playMusic("res://Music/menu_music.ogg")
	theme = load(Settings.theme)
	set_theme(theme)
	get_theme().default_font_size = Settings.font_size
	%large_text.set_pressed_no_signal(Settings.large_toggle)
	%dyslexia.set_pressed_no_signal(Settings.dyslexia_toggle)

func _on_start_pressed():
	AudioManager.playSFX("button")
	get_tree().change_scene_to_file("res://battle/BattleScene.tscn")

func _on_exit_pressed():
	AudioManager.playSFX("button")
	get_tree().quit()

func _on_options_pressed():
	AudioManager.playSFX("button")
	$Options_Menu.show()

func _on_return_pressed():
	AudioManager.playSFX("button")
	#apply changes here
	$Options_Menu.hide()

func _on_large_text_toggled(toggled_on):
	AudioManager.playSFX("button")
	if toggled_on:
		Settings.large_toggle = true
		Settings.font_size = 35
		get_theme().default_font_size = 35

	else:
		Settings.large_toggle = false
		Settings.font_size = 20
		get_theme().default_font_size = 20

func _on_dyslexia_toggled(toggled_on):
	AudioManager.playSFX("button")
	var theme_path
	if toggled_on:
		Settings.dyslexia_toggle = true
		theme_path = "res://ui_theme/dyslexia.tres"
	else:
		Settings.dyslexia_toggle = false
		theme_path = "res://ui_theme/default.tres"
	Settings.theme = theme_path
	theme = load(theme_path)
	set_theme(theme)
	get_theme().default_font_size = Settings.font_size

func _on_tab_bar_tab_button_pressed(tab):
	AudioManager.playSFX("button")
	if tab == 0:
		$Options_Menu/Text_Menu.show()
	elif tab == 1:
		$Options_Menu/Text_Menu.hide()
		
