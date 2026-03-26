extends HFlowContainer
@export var inventory_list: VBoxContainer

var categories := ["all", "offensive_container", "defensive_container", "utility_container"]
var current_index := 0

func _on_offensive_button_pressed() -> void:
	current_index = 1
	inventory_list.show_category(categories[current_index])


func _on_defensive_button_pressed() -> void:
	current_index = 2
	inventory_list.show_category(categories[current_index])


func _on_utility_button_pressed() -> void:
	current_index = 3
	inventory_list.show_category(categories[current_index])


func _on_all_button_pressed() -> void:
	current_index = 0
	inventory_list.show_category(categories[current_index])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_page_left"):
		current_index = max(0, current_index - 1)
		inventory_list.show_category(categories[current_index])
		get_child(current_index).grab_focus()
	elif event.is_action_pressed("ui_page_right"):
		current_index = min(categories.size() - 1, current_index + 1)
		inventory_list.show_category(categories[current_index])
		get_child(current_index).grab_focus()
