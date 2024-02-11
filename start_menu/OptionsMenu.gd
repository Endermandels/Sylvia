extends Control

#Apply saved settings values
func _on_ready():
	theme = load(Settings.theme)
	set_theme(theme)
	get_theme().default_font_size = Settings.font_size
	$MarginContainer/VBoxContainer/dyslexia.set_pressed_no_signal(Settings.dyslexia_toggle)
	$MarginContainer/VBoxContainer/large_text.set_pressed_no_signal(Settings.large_toggle)
	
func _on_return_pressed():
	get_tree().change_scene_to_file('res://start_menu/start_menu.tscn')

func _on_dyslexia_friendly__font_toggled(toggled_on):
	var theme_path
	if(toggled_on == true):
		theme_path = "res://ui_theme/dyslexia.tres"
		Settings.dyslexia_toggle = true
	else:
		theme_path = "res://ui_theme/default.tres"
		Settings.dyslexia_toggle = false
	theme = load(theme_path)
	Settings.theme = theme_path
	set_theme(theme)
	get_theme().default_font_size = Settings.font_size
	
func _on_large_text_toggled(toggled_on):
	if(toggled_on == true):
		get_theme().default_font_size = 35
		Settings.font_size = 35
		Settings.large_toggle = true
	else:
		Settings.font_size = 20
		get_theme().default_font_size = 20
		Settings.large_toggle = false


