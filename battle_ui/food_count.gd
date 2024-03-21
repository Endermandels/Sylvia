extends Control

# the current count of collected food items.
var food_count: int = 0

# reference to the Label node to display the count.
@onready var label: Label = $Sprite2D/Label

func _ready():
	update_label() # initializes with 0

func increment_count():
	# increments the count by one.
	food_count += 1
	update_label()

func decrement_count():
	# decrements the count by one.
	food_count -= 1
	update_label()

func set_count(value: int):
	# sets the count to a specific number.
	food_count = value
	update_label()

func update_label():
	# updates the label with the current count.
	label.text = str(food_count)
