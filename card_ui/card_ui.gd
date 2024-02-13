class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

@onready var state: Label = $State
@onready var drop_point_detector = $dropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] = []

func _ready() -> void:
	card_state_machine.init(self)

# input is triggered when there is an input event.
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

# gui input is triggered when there is an input event on a specific instance of a CardUI
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

#the following are triggered when the users mouse enters and exits the CardUI
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

# ran each time the card enters an Area 2d, that area2d is also added to the targets array.
# this is needed to make sure the card is over the drop zone.
func _on_drop_point_detector_area_entered(area):
	if not targets.has(area):
		targets.append(area)


# when the card leaves an area2d that area2d is removed from the targets list
func _on_drop_point_detector_area_exited(area):
	targets.erase(area)
