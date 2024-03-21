extends GutTest

var character_scene = preload("res://battle/Character.tscn")

func before_each():
	var characterScene = autofree(character_scene.instantiate())
	add_child(characterScene)
	
func after_each():
	remove_child(get_child(get_child_count() - 1))

#acceptence test
#test that inital hearts in the container match the characters maxHP
func test_initial_hearts():
	var character = get_child(get_child_count() - 1)
	assert_eq(character.get_node("Sprite2D/heartsContainer").get_child_count(), character.get_node("Stats").hp, "The number of hearts should match the character's initial HP.")

# acceptence tests
func test_remove_hearts():
	var character = get_child(get_child_count() - 1)
	var hearts_container = character.get_node("Sprite2D/heartsContainer")
	var stats = character.get_node("Stats")
	var initialHealth = stats.hp
	
	hearts_container.removeHearts(1)
	assert_eq(hearts_container.get_child_count(), initialHealth -1, "Should have removed a heart.")
	
	hearts_container.removeHearts(stats.HP + 99)
	assert_eq(hearts_container.get_child_count(), 0, "Should stop remove hearts at 0")
	
# acceptence tests
func test_add_hearts():
	var character = get_child(get_child_count() - 1)
	var hearts_container = character.get_node("Sprite2D/heartsContainer")
	var stats = character.get_node("Stats")
	var initialHealth = stats.hp
	
	hearts_container.addHearts(1)
	assert_eq(hearts_container.get_child_count(), initialHealth + 1, "Should have added a heart.")
	
	hearts_container.addHearts(stats.HP + 99)
	assert_eq(hearts_container.get_child_count(), stats.HP, "Should not add more hearts than max health")
	
	
#integration Test
#tests integration of hearts container with receiveDMG function in Stats
#since the reciveDMG is higher level than the hearts_container, this is a top-down approach
func test_damage_taken():
	var character = get_child(get_child_count() - 1)
	var hearts_container = character.get_node("Sprite2D/heartsContainer")
	var stats = character.get_node("Stats")
	var initialHealth = stats.hp
	stats.receiveDMG(1)
	assert_eq(stats.hp, initialHealth -1, "Stats must update when damage is taken be character.")
	assert_eq(stats.hp,hearts_container.get_child_count(), "Number of hearts in hearts_container must equal character HP.")
	
	

#White box tests for setHearts function, path coverage
	'''
	func setHearts(num: int):
	var current_hearts = get_child_count()
	if num > current_hearts: # we need to add hearts
		addHearts(num - current_hearts)
	elif num < current_hearts: # we have too many hearts, remove the excess
		removeHearts(current_hearts - num)
	'''
func test_SetHearts():
	
	var character = get_child(get_child_count() - 1)
	var hearts_container = character.get_node("Sprite2D/heartsContainer")
	var stats = character.get_node("Stats")
	var currentHearts = stats.hp
	
	
	# test that hearts increase if currently less
	hearts_container.setHearts(currentHearts + 1)
	assert_eq(hearts_container.get_child_count(), currentHearts + 1, "Should have correct number of hearts after adding.")
	currentHearts = hearts_container.get_child_count()
	
	# test hearts decrease if currently more
	hearts_container.setHearts(currentHearts - 1)
	assert_eq(hearts_container.get_child_count(), currentHearts - 1, "Should have correct number of hearts after adding.")
	currentHearts = hearts_container.get_child_count()
	
	# test hearts stay the same if current match set
	hearts_container.setHearts(currentHearts)
	assert_eq(hearts_container.get_child_count(), currentHearts, "Should have correct number of hearts after adding.")

	
	
	
	
	
