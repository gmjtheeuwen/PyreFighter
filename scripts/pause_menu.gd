extends Control

signal continued

func _on_continue_button_pressed():
	continued.emit()
	
func _on_quit_button_pressed():
	Engine.time_scale = 1
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
