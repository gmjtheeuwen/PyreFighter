extends MarginContainer


var item: item_data

signal equipped_state_changed(is_equipped: bool, equipment_name: String)
signal fade_completed
signal fade_back_completed

func _setup(data: item_data):
	item = data
	$PanelContainer/TextureRect.texture = data.icon
	$PanelContainer/VBoxContainer/title.text = data.display_name
	$PanelContainer/VBoxContainer/Desc.text = data.description


func _on_button_pressed() -> void:
	var inventory: inventory_data = load("res://resources/inventory.tres")
	
	if item.is_equipped:
		item.is_equipped = false
		inventory.equipped_item_id = ""
	else:
		for i in inventory.all_items:
			i.is_equipped = false
		item.is_equipped = true
		inventory.equipped_item_id = item.id
		print("succesfully equiped:", inventory.equipped_item_id)
	
	ResourceSaver.save(inventory, "res://resources/inventory.tres")
	emit_signal("equipped_state_changed", item.is_equipped, item.display_name)


func _on_texture_rect_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($PanelContainer/TextureRect, "self_modulate", Color(1.3, 1.3, 1.3, 1.0), 0.1)


func _on_texture_rect_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($PanelContainer/TextureRect, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)

func _on_focus_entered() -> void:
	var tween = create_tween()
	tween.tween_property($PanelContainer/TextureRect, "self_modulate", Color(1.3, 1.3, 1.3, 1.0), 0.1)

func _on_focus_exited() -> void:
	var tween = create_tween()
	tween.tween_property($PanelContainer/TextureRect, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)

func play_fade():
	$PanelContainer/TextureRect.play_fade()

func play_fade_back():
	$PanelContainer/VBoxContainer.play_fade_back()

func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "fade":
		emit_signal("fade_completed")
	elif anim_name == "fade_back":
		emit_signal("fade_back_completed")
