extends Node
class_name State

signal finished(new_state: String, data: Dictionary)

func enter(_data: Dictionary):
	pass
	
func exit():
	pass
	
func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass
	
func handle_input(_event: InputEvent):
	pass
