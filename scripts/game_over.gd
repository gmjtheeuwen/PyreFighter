extends PanelContainer

func _on_restart():
	get_tree().change_scene_to_file("res://scenes/mission_select.tscn")
