extends GutTest
var main_scene = preload("res://start_menu/start_menu.tscn")
var battle_scene = preload("res://battle/BattleScene.tscn")

#white box test the path to main menu should be loadable, covers functions
#in various scenes that return to menu from their respective scene
func test_main_menu():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	assert_ne(main_node, null, "failed to load main menu from path, exiting")
	if main_node == null:
		get_tree().quit()

#acceptence test
func test_default_size():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var control_nodes = get_control_nodes(main_node)
	for node in control_nodes:
		assert_true(node.get_theme_default_font_size() == 20, "Starting text size not default")

#acceptence test
func test_main_menu_press_on():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	var control_nodes = get_control_nodes(main_node)
	for node in control_nodes:
		assert_true(node.get_theme_default_font_size() == 35, "Did not toggle text on main menu")

#acceptence test
func test_main_menu_press_off():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	button.set_pressed(false)
	var control_nodes = get_control_nodes(main_node)
	for node in control_nodes:
		assert_true(node.get_theme_default_font_size() == 20)

#acceptance test
func test_battle_menu_default():
	var battle_node = battle_scene.instantiate()
	add_child_autofree(battle_node)
	var control_nodes = get_control_nodes(battle_node)
	for node in control_nodes:
		assert_true(node.get_theme_default_font_size() == 20)

#acceptance test
func test_battle_menu_on():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	var battle_node = battle_scene.instantiate()
	add_child_autofree(battle_node)
	var control_nodes = get_control_nodes(battle_node)
	for node in control_nodes:
		assert_true(node.get_theme_default_font_size() == 35)

#acceptance test
func test_battle_menu_off():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	button.set_pressed(false)
	var battle_node = battle_scene.instantiate()
	add_child_autofree(battle_node)
	var control_nodes = get_control_nodes(battle_node)
	for node in control_nodes:
		assert_true(node.get_theme_default_font_size() == 20)

#integration test tests button toggle in one scene affects settings toggle in another
#Also tests expected behavior of large text and dyslexia settigngs
#The units are dyslexia toggle, large_text_toggle, start_menu scene, and battle_scene
#I chose bottom- up integration testing by testing the individual features (the buttons), then 
#adding complexity (persistance accross scenes)
func test_no_menu_dyslexia_and_no_large_text():		#default
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var control_nodes = get_control_nodes(main_node)
	for node in control_nodes:
		if node is Button:
			var font = load("res://ui_theme/Font/Montserrat-Regular.ttf")
			assert_true(node.get_theme_default_font_size() == 20 and node.get_theme_default_font() == font)


#integration test
func test_menu_dyslexia_and_no_large_text():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var dyslexia = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/dyslexia")
	dyslexia.set_pressed(true)
	var control_nodes = get_control_nodes(main_node)
	for node in control_nodes:
		if node is Button:
			var font = load("res://ui_theme/Font/OpenDyslexic-Regular.otf")
			assert_true(node.get_theme_default_font_size() == 20 and node.get_theme_default_font() == font)

#integration test
func test_menu_dyslexia_and_large_text():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var dyslexia = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/dyslexia")
	dyslexia.set_pressed(true)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	var control_nodes = get_control_nodes(main_node)
	for node in control_nodes:
		if node is Button:
			var font = load("res://ui_theme/Font/OpenDyslexic-Regular.otf")
			assert_true(node.get_theme_default_font_size() == 35 and node.get_theme_default_font() == font)

#integration test
func test_menu_no_dyslexia_and_large_text():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var dyslexia = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/dyslexia")
	dyslexia.set_pressed(true)
	dyslexia.set_pressed(false)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	var control_nodes = get_control_nodes(main_node)
	for node in control_nodes:
		if node is Button:
			var font = load("res://ui_theme/Font/Montserrat-Regular.ttf")
			assert_true(node.get_theme_default_font_size() == 35 and node.get_theme_default_font() == font)

#integration test
func test_no_battle_dyslexia_and_no_large_text():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	button.set_pressed(false)
	var dyslexia = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/dyslexia")
	dyslexia.set_pressed(true)
	dyslexia.set_pressed(false)	
	var battle_node = battle_scene.instantiate()
	add_child_autofree(battle_node)
	var control_nodes = get_control_nodes(battle_node)
	for node in control_nodes:
		if node is Button:
			var font = load("res://ui_theme/Font/Montserrat-Regular.ttf")
			assert_true(node.get_theme_default_font_size() == 20 and node.get_theme_default_font() == font)

#integration test
func test_battle_dyslexia_and_no_large_text():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	button.set_pressed(false)
	var dyslexia = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/dyslexia")
	dyslexia.set_pressed(true)
	var battle_node = battle_scene.instantiate()
	add_child_autofree(battle_node)
	var control_nodes = get_control_nodes(battle_node)
	for node in control_nodes:
		if node is Button:
			var font = load("res://ui_theme/Font/OpenDyslexic-Regular.otf")
			assert_true(node.get_theme_default_font_size() == 20 and node.get_theme_default_font() == font)

#integration test
func test_battle_dyslexia_and_large_text():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	var dyslexia = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/dyslexia")
	dyslexia.set_pressed(true)
	var battle_node = battle_scene.instantiate()
	add_child_autofree(battle_node)
	var control_nodes = get_control_nodes(battle_node)
	for node in control_nodes:
		if node is Button:
			var font = load("res://ui_theme/Font/OpenDyslexic-Regular.otf")
			assert_true(node.get_theme_default_font_size() == 35 and node.get_theme_default_font() == font)

#integration test
func test_battle_no_dyslexia_and_large_text():
	var main_node = main_scene.instantiate()
	add_child_autofree(main_node)
	var button = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/large_text")
	button.set_pressed(true)
	var dyslexia = main_node.get_node("Options_Menu/TabContainer/Text/VBoxContainer/dyslexia")
	dyslexia.set_pressed(true)
	dyslexia.set_pressed(false)
	var battle_node = battle_scene.instantiate()
	add_child_autofree(battle_node)
	var control_nodes = get_control_nodes(battle_node)
	for node in control_nodes:
		if node is Button:
			var font = load("res://ui_theme/Font/Montserrat-Regular.ttf")
			assert_true(node.get_theme_default_font_size() == 35 and node.get_theme_default_font() == font)

#returns all control nodes in a scene 
func get_control_nodes(node):
	var control_nodes = []
	if node is Control:
		control_nodes.append(node)
	for child in node.get_children():
		var child_control_nodes = get_control_nodes(child)
		control_nodes += child_control_nodes
	return control_nodes
	
func generate_text_params():
	var scenes = ["res://start_menu/start_menu.tscn", "res://battle/BattleScene.tscn"]
	var font_sizes = [20, 35]
	var font_themes = ["res://ui_theme/dyslexia.tres", "res://ui_theme/dyslexia.tres"]
	var text_params = []
	for scene in scenes:
		for font_size in font_sizes:
				var param = [scene, font_size]
				text_params.append(param)
	return text_params
	
