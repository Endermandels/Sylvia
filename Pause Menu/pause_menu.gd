extends Control

@onready var battle_scene = $"../../"

func _on_resume_pressed():
	battle_scene.pauseMenu()
