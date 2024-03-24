extends GutTest

var FoodCounter = preload("res://battle_ui/food_count.tscn")
var BattleScene = preload("res://battle/BattleScene.tscn")

func before_each():
	var FoodCounter = autofree(FoodCounter.instantiate())
	add_child(FoodCounter)
	
func after_each():
	remove_child(get_child(get_child_count() - 1))
	
#acceptance tests
#make sure initial value of coutner and label are 0
func test_initial_value():
	var counter = get_child(get_child_count() - 1)
	assert_eq(counter.get_node("Sprite2D/Label").text, "0", "initial FoodCount label must be 0.")
	assert_eq(counter.food_count, 0, "initial food_count must be 0.")

#acceptance tests
#ensure counter is incremented correctly
func test_increment():
	var counter = get_child(get_child_count() - 1)
	var initial_count = counter.food_count
	counter.increment_count()
	assert_eq(counter.food_count, initial_count+1, "food_count should have incremented.")

#acceptance tests
#ensure setting the counter works
func test_set_count():
	var counter = get_child(get_child_count() - 1)
	var initial_count = counter.food_count
	counter.set_count(2)
	assert_eq(counter.food_count, 2, "Counter should set too 2.")
	counter.set_count(0)
	assert_eq(counter.food_count, 0, "Counter should set too 0.")
	counter.set_count(-1)
	assert_eq(counter.food_count, 0, "Counter should not go below 0")

#acceptance tests
#ensure updating counter label works
func test_update_label():
	var counter = get_child(get_child_count() - 1)
	counter.food_count = 10
	counter.update_label()
	assert_eq(counter.get_node("Sprite2D/Label").text, "10", "Counter Label should set too 10.")
	counter.food_count = 0
	counter.update_label()
	assert_eq(counter.get_node("Sprite2D/Label").text, "0", "Counter Label should set too 0.")
	
	
#Integration Test
#tests how the character integrates with the food counter. 
#This is like a big-bang approach as the whole battle scene is instantiated for this test.
func test_character_collect_moresel():
	#setup battlescene
	remove_child(get_child(get_child_count() - 1))
	var BattleScene = autofree(BattleScene.instantiate())
	add_child(BattleScene)
	var battle_scene = get_child(get_child_count() - 1)
	
	var food_counter = battle_scene.get_node("FoodCounter")
	var player = battle_scene.get_node("Characters/Clover")
	var FoodSpaces = battle_scene.get_node("FoodSpaces")
	player.grid_pos = FoodSpaces.get_child(get_child_count() - 1).grid_pos #put player over food
	battle_scene._on_collect_food_button_pressed()
	
	assert_eq(food_counter.food_count, 1, "Player should have collected a single morsel.")
	
	
