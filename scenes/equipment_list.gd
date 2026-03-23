extends VBoxContainer


func _on_reorder_requested(category_name: String, direction: String):
	print("request received for: ", category_name)
	var node = get_node(category_name)
	var current_pos = node.get_index()
	
	if direction == "up" and current_pos > 0:
		move_child(node, 0)
		print("up success")
	elif direction == "down" and current_pos < get_child_count() - 1:
		move_child(node, current_pos + 1)
		print("down success")
