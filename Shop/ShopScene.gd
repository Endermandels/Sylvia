class_name ShopScene
extends Node2D

signal completed

func test_button_signal_completed() -> void:
	completed.emit()
