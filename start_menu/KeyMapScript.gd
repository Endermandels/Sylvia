extends Control
var action
var new_action

func _on_up_pressed():
	action = "ui_up"
	%Listener.show()
	
func _on_down_pressed():
	action = "ui_down"
	%Listener.show()
	
func _on_left_pressed():
	action = "ui_left"
	%Listener.show()
	
func _on_right_pressed():
	action = "ui_right"
	%Listener.show()

func _on_accept_pressed():
	action = "ui_accept"
	%Listener.show()

func _unhandled_input(event) -> void:
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed():
		accept_event()
		new_action = event
		var text = "Save " + new_action.as_text() + " as " + action + "?"
		%ConfirmAction.dialog_text = text
		%ConfirmAction.show()

func _on_confirm_action_confirmed():
	InputHelper.set_keyboard_input_for_action(action, new_action)
	%Listener.hide()

func _on_confirm_action_canceled():
	%Listener.hide()

func _on_return_pressed():
	%InputPopUp.hide()
