extends Node
var deviceType = "Default"

func _ready() -> void:
	InputHelper.guess_device_name() # Maybe "xbox" if you have an XBox controller plugged in
	InputHelper.device_changed.connect(_on_input_device_changed)
	print(deviceType)
	

func _on_input_device_changed(device: String, device_index: int) -> void:
	print("XBox? ", device == InputHelper.DEVICE_XBOX_CONTROLLER)
	print("Device index? ", device_index) # Probably 0
