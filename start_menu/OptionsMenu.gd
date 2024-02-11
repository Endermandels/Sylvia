extends Control

func _on_ready():
	if Settings.theme != "default":
		theme = load("res://ui_theme/dyslexia.tres")
		$MarginContainer/VBoxContainer/dyslexia.set_pressed_no_signal(true)
		set_theme(theme)
	else:
		theme = load("res://ui_theme/default.tres")
		set_theme(theme)
		
	if Settings.font_size != null:
		$MarginContainer/VBoxContainer/large_text.set_pressed_no_signal(true)
		
func _on_return_pressed():
	#this is when the changes should be applied to the rest of the game
	get_tree().change_scene_to_file('res://start_menu/start_menu.tscn')

func _on_dyslexia_friendly__font_toggled(toggled_on):
	if(toggled_on == true):
		theme = load("res://ui_theme/dyslexia.tres")
		set_theme(theme)
		Settings.theme = "dyslexia"
	else:
		theme = load("res://ui_theme/default.tres")
		set_theme(theme)
		Settings.theme = "default"
		
func _on_large_text_toggled(toggled_on):
	if(toggled_on == true):
		Settings.font_size = 80
		print("Large text on")
	else:
		Settings.font_size = null
		print("default text size")


