extends Control

@onready var battle_scene = $"../../"
@onready var volume_settings = $volume_settings

func _on_resume_pressed():
	battle_scene.pauseMenu()
	
func _on_settings_pressed():
	volume_settings.show()
	
