# This is a class named CardState that extends the Node class in Godot.
class_name CardState
extends Node

# An enumeration named State is defined with three possible values: BASE, DRAGGING, RELEASED.
enum State {BASE, DRAGGING, RELEASED}

# A signal named transition_requested is defined. It expects two parameters: a CardState object and a State enum value.
signal transition_requested(from: CardState, to: State)

# An exported variable named state of type State is defined. 
@export var state: State

var card_ui: CardUI

# below are placeholder functions that are expected to be overridden in subclasses.

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func on_input(_event: InputEvent) -> void:
	pass

func on_gui_input(_event: InputEvent) -> void:
	pass
	
func on_mouse_entered() -> void:
	pass

func on_mouse_exited() -> void:
	pass
