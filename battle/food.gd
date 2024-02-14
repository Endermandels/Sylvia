extends Node2D

var waiting = false

@onready var collectSprite = $Collect
@onready var ignoreSprite = $Ignore

# requires a decision from the player: pause other actions
signal decision_collect_food 
signal collect_food # player decided to collect food
signal ignore_food # player decided to ignore the food

func _ready():
	hide_sprites()

func hide_sprites():
	collectSprite.visible = false
	ignoreSprite.visible = false

"""
When a player character enters a food space, 
ask the player if they want to collect the food.
"""
func _on_area_2d_area_entered(area):
	emit_signal("decision_collect_food")
	collectSprite.visible = true
	ignoreSprite.visible = true
	waiting = true

"""
Collect Sprite clicked.
"""
func _on_collect_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("collect_food")
		waiting = false
		hide_sprites()

"""
Ignore Sprite clicked.
"""
func _on_ignore_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("ignore_food")
		waiting = false
		hide_sprites()
