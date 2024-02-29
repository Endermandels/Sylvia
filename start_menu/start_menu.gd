extends Control


func _on_ready():
	theme = load(Settings.theme)
	set_theme(theme)
	get_theme().default_font_size = Settings.font_size
	%large_text.set_pressed_no_signal(Settings.large_toggle)
	%dyslexia.set_pressed_no_signal(Settings.dyslexia_toggle)
	%keyboard.set_pressed_no_signal(Settings.keyboard_toggle)
	%Start.grab_focus()
		
func _on_start_pressed():
	get_tree().change_scene_to_file("res://battle/BattleScene.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_options_pressed():
	$Options_Menu.show()
	$Options_Menu/TabContainer.current_tab = 0;
	$Options_Menu/TabContainer/Text/VBoxContainer/return.grab_focus()

func _on_return_pressed():
	#apply changes here
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


func _on_keyboard_toggled(toggled_on):
	if toggled_on:
		print("Allow keyboard input")
		Settings.keyboard_toggle = true
		var button_focus = load("res://ui_theme/button_focus.tres")
		get_theme().merge_with(button_focus)
		$Options_Menu/TabContainer/Controls/VBoxContainer/return.grab_focus()
		
	else:
		print("No longer allowing keyboard input")
		Settings.keyboard_toggle = false
		get_theme().clear()
