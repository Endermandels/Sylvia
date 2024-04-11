extends Control

@onready var battle_scene = $"../../"
@onready var volume_settings = $volume_settings

func _on_resume_pressed():
	battle_scene.pauseMenu()
	
func _on_settings_pressed():
	volume_settings.show()
	


func _on_xbox_controls_ready():
	if InputHelper.device == "xbox":
		if InputHelper.default == true:
			$XboxControls.show()
		else:
			$userControls.show()


func _on_keyboard_controls_ready():
	if InputHelper.device != "xbox":
		if InputHelper.default == true:
			$KeyboardControls.show()
		else:
			$userControls.show()
			
