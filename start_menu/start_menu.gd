extends Control

#Apply saved settings values
func _on_ready():
	theme = load(Settings.theme)
	set_theme(theme)
	get_theme().default_font_size = Settings.font_size
	$Options_Menu/MarginContainer/VBoxContainer/large_text.set_pressed_no_signal(Settings.large_toggle)
	$Options_Menu/MarginContainer/VBoxContainer/dyslexia.set_pressed_no_signal(Settings.dyslexia_toggle)
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://battle/BattleScene.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_options_pressed():
	$Options_Menu.show()

func _on_return_pressed():
	#apply changes
	$Options_Menu.hide()

func _on_large_text_toggled(toggled_on):
	if toggled_on:
		Settings.large_toggle = true
		Settings.font_size = 35
		get_theme().default_font_size = 35

	else:
		Settings.large_toggle = false
		Settings.font_size = 20
		get_theme().default_font_size = 20

func _on_dyslexia_toggled(toggled_on):
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
