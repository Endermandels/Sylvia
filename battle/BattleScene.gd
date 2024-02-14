extends Node2D

# Keeps track of game states
enum State {
	PLAYER_TURN,
	ENEMY_TURN
}

var gamestate = State.PLAYER_TURN

signal enemys_turn
signal players_turn

"""
When the player ends their turn, signal that it is the enemy's turn.
"""
func _on_end_of_turn_end_turn():
	if gamestate == State.PLAYER_TURN:
		gamestate = State.ENEMY_TURN
		emit_signal("enemys_turn")


"""
When the enemy ends their turn, signal that it is the player's turn.
"""
func _on_enemy_end_turn():
	if gamestate == State.PLAYER_TURN:
		print('! ERROR: Enemy passed turn before player')
		get_tree().quit()
	
	gamestate = State.PLAYER_TURN
	emit_signal("players_turn")
