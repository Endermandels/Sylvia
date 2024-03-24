extends CardState

func enter() -> void:
	
	#detach the card from the hand container so that it can move about.
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
	
	card_ui.state.text = "DRAGGING"
	
	
func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse")
	
	
	# if the event was mouse motion then update the global position of the card.
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
		
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif confirm:
		get_viewport().set_input_as_handled() #prevent other nodes from reciving this input
		transition_requested.emit(self, CardState.State.RELEASED)
		
