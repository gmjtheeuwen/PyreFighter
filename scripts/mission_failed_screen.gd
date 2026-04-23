extends CenterContainer

func _on_button_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/hub.tscn")
