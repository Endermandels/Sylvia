extends GutTest

var BattleScene = preload("res://battle/BattleScene.tscn")

func before_each():
	var BattleScene = autofree(BattleScene.instantiate())
	add_child(BattleScene)
	
func after_each():
	remove_child(get_child(get_child_count() - 1))

#acceptence tests for Card State Machine
# each of the following three tests to ensure that the card is able to enter each state
# after particular events happen.
func test_initial_state():
	var battle_scene = get_child(get_child_count() - 1)
	var hand = battle_scene.get_node("BattleUI/Hand")
	var card_ui = hand.get_child(0)
	var state_machine = card_ui.get_node("CardStateMachine")
	# test that the card is initally in base state
	assert_eq(state_machine.current_state, state_machine.states[CardState.State.BASE], "Card should Start in BASE state.")
	
func test_enter_dragging_state():
	var battle_scene = get_child(get_child_count() - 1)
	var hand = battle_scene.get_node("BattleUI/Hand")
	var card_ui = hand.get_child(0)
	var state_machine = card_ui.get_node("CardStateMachine")
	
	var event = InputEventMouseButton.new() 
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	card_ui._on_gui_input(event)#simmulate mouse left click
	
	#test that card is in dragging state after it is left pressed on
	assert_eq(state_machine.current_state, state_machine.states[CardState.State.DRAGGING], "Card should enter the DRAGGING state.")
	
func test_card_enter_released_state():
	var battle_scene = get_child(get_child_count() - 1)
	var hand = battle_scene.get_node("BattleUI/Hand")
	var card_ui = hand.get_child(0)
	var state_machine = card_ui.get_node("CardStateMachine")
	
	#card already needs to be in dragging state
	var event = InputEventMouseButton.new() 
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	card_ui._on_gui_input(event)
	
	var drop_zone = Area2D.new() # card needs to be over a target
	card_ui._on_drop_point_detector_area_entered(drop_zone)
	
	event.pressed = false
	card_ui._input(event) # left click needs to be released
	#test that card has entered released state
	assert_eq(state_machine.current_state, state_machine.states[CardState.State.RELEASED], "Card should enter the RELEASED state.")
