extends Control

@onready var colorRect = $Panel/ColorRect
@onready var panel = $Panel

func on_health_changed(value: float):
	colorRect.size.x = panel.size.x * value
