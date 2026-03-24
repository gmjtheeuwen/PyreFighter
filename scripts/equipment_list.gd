extends VBoxContainer
const ITEM_CARD = preload("res://scenes/item.tscn")

func _ready() -> void:
	var inventory: inventory_data = load("res://resources/inventory.tres")
	var categorized := {
		item_data.Type.OFFENSIVE: [],
		item_data.Type.DEFENSIVE: [],
		item_data.Type.UTILITY: []
	} 
	
	for item in inventory.all_items:
		if item.is_unlocked:
			categorized[item.type].append(item)
		
	_populate_category(categorized[item_data.Type.OFFENSIVE], $offensive_container)
	_populate_category(categorized[item_data.Type.DEFENSIVE], $defensive_container)
	_populate_category(categorized[item_data.Type.UTILITY], $utility_container)
	
func _populate_category(items: Array, container: Node):
	var flow = container.get_node("HFlowContainer")
	for data in items:
		var card = ITEM_CARD.instantiate()
		flow.add_child(card)
		card.setup(data)
		card.equipped_state_changed.connect(_on_equipped_state_changed)

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

func _on_equipped_state_changed(is_equipped: bool):
	var count = 1 if is_equipped else 0
	get_node("../../../limit_label").text = "equipment limit " + str(count) + "/ 1"
