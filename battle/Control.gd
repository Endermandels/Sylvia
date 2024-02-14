extends Control
func _on_ready():
	theme = load(Settings.theme)
	set_theme(theme)
	get_theme().default_font_size = Settings.font_size
