extends Control

func _on_return_pressed():
	get_tree().change_scene_to_file('res://start_menu/start_menu.tscn')


func _on_dyslexia_friendly__font_toggled(toggled_on):
	if(toggled_on == true):
		print("dyslexia friendly font on")
	else:
		print("default font on")


func _on_large_text_toggled(toggled_on):
	if(toggled_on == true):
		print("large text on")
	else:
		print("default text size on")
