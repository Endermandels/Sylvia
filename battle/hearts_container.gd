extends HBoxContainer

@onready var stats = $"../../Stats"
@onready var HeartGuiClass = preload("res://battle/heart_gui.tscn")
@onready var maxHP = stats.HP
# Called when the node enters the scene tree for the first time.
func _ready():
	setHearts(maxHP) # adds max hp hearts to the character

func setHearts(num: int):
	var current_hearts = get_child_count()
	if num > current_hearts: # we need to add hearts
		addHearts(num - current_hearts)
	elif num < current_hearts: # we have too many hearts, remove the excess
		removeHearts(current_hearts - num)
	
#function for adding hearts to container
func addHearts(num: int): 
	for i in range(num):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

#function for removing hearts from container
func removeHearts(num: int):
	for i in range(num):
		if get_child_count() > 0:
			var last_heart = get_child(get_child_count() - 1)
			remove_child(last_heart)
			last_heart.queue_free()

		
		
