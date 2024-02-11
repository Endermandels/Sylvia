extends Control

#Apply saved settings values
func _on_ready():
	theme = load(Settings.theme)
	set_theme(theme)
	get_theme().default_font_size = Settings.font_size
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://battle/BattleScene.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_options_pressed():
	get_tree().change_scene_to_file('res://start_menu/options_menu.tscn')
