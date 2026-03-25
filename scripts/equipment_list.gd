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
	
	show_category("offensive_container")
	var first_card = $offensive_container/HFlowContainer.get_child(0)
	if first_card:
		first_card.grab_focus()

func _populate_category(items: Array, container: Node):
	var flow = container.get_node("HFlowContainer")
	var cards = []
	for data in items:
		var card = ITEM_CARD.instantiate()
		flow.add_child(card)
		card.setup(data)
		card.equipped_state_changed.connect(_on_equipped_state_changed)
	
	for i in cards.size():
		if i > 0:
			cards[i].focus_neighbor_left = cards[i].get_path_to(cards[i - 1])
			cards[i - 1].focus_neighbor_right = cards[i].get_path_to(cards[i])

func show_category(category_name: String) -> void:
	if category_name == "all":
		$offensive_container.visible = true
		$defensive_container.visible = true
		$utility_container.visible = true
	else:
		$offensive_container.visible = false
		$defensive_container.visible = false
		$utility_container.visible = false
		get_node(category_name).visible = true

func _on_equipped_state_changed(is_equipped: bool, item_name: String):
	var count = 1 if is_equipped else 0
	get_node("../../../limit_label").text = "equipment limit " + str(count) + "/ 1"
	get_node("../../../equipped_label").text = "currently equipped: " + str(item_name)
