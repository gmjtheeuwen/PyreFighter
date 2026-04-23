extends CenterContainer

func _on_start_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/hub.tscn")

func _on_quit_pressed():
	get_tree().quit()
