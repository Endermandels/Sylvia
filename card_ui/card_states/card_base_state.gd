extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	card_ui.reparent_requested.emit(card_ui) #signal emited to reparent card to the hand container
	card_ui.state.text = "CARD"
	card_ui.pivot_offset = Vector2.ZERO

# function is ran when there is input over the specific card.
func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		# set the cards pivot offset to match where the mouse is
		# this way the card moves exactly with the mouse
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.DRAGGING)
