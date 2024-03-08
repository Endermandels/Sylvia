extends "res://addons/gut/test.gd"

@onready var player = preload("res://battle/Character.tscn").instantiate()
@onready var enemy = preload("res://battle/Enemy.tscn").instantiate()

func _ready():
	player.set_name('Clover')
	add_child(player)
	enemy.set_name('Dummy')
	add_child(enemy)

'''
This is a white box test for the attack function in enemy.gd which has
function coverage, which essentially just reduces an animal's hp.

This test is also an integration test since the player is from
the character.gd and the enemy is from the enemy.gd
in which gd scripts are classes. The approach of the integration test
taken here is bottom-up.

The code for the attack function is shown below:

func attack(damage, animal):
	var animal_stats = animal.get_node("Stats")
	print('Player attacked for ' + str(damage))
	animal_stats.receiveDMG(stats.atk)
	print('Player remaining HP ' + str(animal_stats.hp))
'''
func test_attack():
	var max_hp = player.stats.hp
	var atk = enemy.stats.atk
	assert_eq(max_hp - atk, enemy.attack(atk, player),
	"Player did not take the correct amount of damage.")

var cannot_move_params=[
	["move", [[0, 0]]],
	["move", [[0, 1]]],
	["move", [[0, 2]]],
	["move", [[0, 3]]],
	["move", [[0, 4]]],
	["move", [[1, 1]]],
	["move", [[1, 2]]],
	["move", [[1, 3]]],
	["move", [[1, 4]]],
	["move", [[2, 2]]],
	["move", [[2, 3]]],
	["move", [[2, 4]]],
	["move", [[3, 3]]],
	["move", [[3, 4]]],
	["move", [[4, 2]]],
	["move", [[4, 3]]],
	["move", [[4, 4]]],
	["move", [[5, 1]]],
	["move", [[5, 2]]],
	["move", [[5, 3]]],
	["move", [[5, 4]]],
	["move", [[6, 0]]],
	["move", [[6, 1]]],
	["move", [[6, 2]]],
	["move", [[6, 3]]],
	["move", [[6, 4]]]
]

'''
This is a black box acceptance that uses the parameters cannot_move_params.
to test the generate_move_list function in enemy.gd.
'''
func test_enemy_cannot_move_to(params=use_parameters(cannot_move_params)):
	var result = enemy.generate_move_list([3,0], 2)
	assert_false(result.has(params), "Enemy should not be able to move here.")
	
var can_move_params = [
	["move", [[1, 0]]],
	["move", [[2, 0]]],
	["move", [[2, 1]]],
	["move", [[3, 0]]],
	["move", [[3, 1]]],
	["move", [[3, 2]]],
	["move", [[4, 0]]],
	["move", [[4, 1]]],
	["move", [[5, 0]]]
]

'''
This is a black box acceptance that uses the parameters can_move_params.
to test the generate_move_list function in enemy.gd.
'''
func test_enemy_can_move_to(params=use_parameters(can_move_params)):
	var result = enemy.generate_move_list([3,0], 2)
	assert_true(result.has(params), "Enemy should be able to move here.")
