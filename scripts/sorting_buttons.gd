extends HFlowContainer
@export var inventory_list: VBoxContainer




func _on_offensive_button_pressed() -> void:
	inventory_list._on_reorder_requested("offensive_container", "up")


func _on_defensive_button_pressed() -> void:
	inventory_list._on_reorder_requested("defensive_container", "up")


func _on_utility_button_pressed() -> void:
	inventory_list._on_reorder_requested("utility_container", "up")
