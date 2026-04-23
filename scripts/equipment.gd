extends Node2D

@onready var label = $Label
@onready var timer = $Timer

func on_use_equipment(_direction):
	label.visible = true
	timer.start()

func on_timeout():
	label.visible = false
