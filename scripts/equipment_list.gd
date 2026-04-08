extends VBoxContainer
const ITEM_CARD: = preload("res://scenes/item.tscn")

func _ready() -> void:
	var inventory: inventory_data = load("res://resources/inventory.tres")
	var categorized := {
		ItemData.Type.OFFENSIVE: [],
		ItemData.Type.DEFENSIVE: [],
		ItemData.Type.UTILITY: []
	}
	
	for item in inventory.all_items:
		if item.is_unlocked:
			categorized[item.type].append(item)
	
	_populate_category(categorized[ItemData.Type.OFFENSIVE], $offensive_container)
	_populate_category(categorized[ItemData.Type.DEFENSIVE], $defensive_container)
	_populate_category(categorized[ItemData.Type.UTILITY], $utility_container)
	
	show_category("offensive_container")
	var first_card = $offensive_container/HFlowContainer.get_child(0)
	if first_card:
		first_card.grab_focus()

func _populate_category(items: Array, container: Node) -> void:
	var flow = container.get_node("HFlowContainer")
	for data in items:
		var card = ITEM_CARD.instantiate()
		flow.add_child(card)
		card._setup(data)
		card.equipped_state_changed.connect(_on_equipped_state_changed)
		card.fade_completed.connect(_on_item_fade_completed.bind(card))
		card.fade_back_completed.connect(_on_item_fade_back_completed.bind(card))
		card.focus_entered.connect(_on_card_focus_entered.bind(card))

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
