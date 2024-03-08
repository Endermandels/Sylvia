class_name Hand
extends HBoxContainer

signal play_card(card, targets)

func _ready() -> void:
	#connect signal for each card
	for child in get_children():
		var card_ui := child as CardUI
		card_ui.reparent_requested.connect(_on_card_ui_reparet_requested)

func _process(_delta):
	for card in get_children():
		if card.released_state.played:
			card.released_state.played = false
			play_card.emit(card, card.released_state.targets)

# when a card enters based state and emits reparent, 
# it is added to the hand container.
func _on_card_ui_reparet_requested(child:CardUI) -> void:
	child.reparent(self)
