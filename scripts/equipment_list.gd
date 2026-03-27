extends VBoxContainer
const ITEM_CARD = preload("res://scenes/item.tscn")

var _nav_cooldown := false
var _using_controller := false

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

func _focus_card(card: MarginContainer) -> void:
	var texture_rect = card.get_node("PanelContainer/TextureRect")
	var button = card.get_node("PanelContainer/VBoxContainer/Button")
	if not texture_rect.visible:
		button.grab_focus()
	else:
		card.grab_focus()

func _on_equipped_state_changed(is_equipped: bool, item_name: String) -> void:
	var count = 1 if is_equipped else 0
	get_node("../../../limit_label").text = "equipment limit " + str(count) + "/ 1"
	get_node("../../../equipped_label").text = "currently equipped: " + str(item_name)

func _input(event: InputEvent) -> void:
	# Detect input method switch
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if not _using_controller:
			_using_controller = true
			_grab_first_visible_focus()
	elif event is InputEventMouseButton or event is InputEventMouseMotion or event is InputEventKey:
		_using_controller = false
	
	var focused = get_viewport().gui_get_focus_owner()
	var is_equip_button = focused and focused is Button and \
		focused.get_parent().get_parent().get_parent() is MarginContainer
	
	if event.is_action_pressed("ui_accept"):
		if focused and focused is MarginContainer:
			focused.play_fade()
			get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_cancel"):
		if is_equip_button:
			focused.get_parent().get_parent().get_parent().play_fade_back()
			get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or \
		event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		if _nav_cooldown:
			get_viewport().set_input_as_handled()
			return
		
		if is_equip_button:
			get_viewport().set_input_as_handled()
			var card = focused.get_parent().get_parent().get_parent()
			var flow = card.get_parent()
			var card_index = card.get_index()
			var cards_in_row = 0
			for i in flow.get_child_count():
				if flow.get_child(i).global_position.y == card.global_position.y:
					cards_in_row += 1
			
			if event.is_action_pressed("ui_up"):
				if card_index >= cards_in_row:
					_focus_card(flow.get_child(card_index - cards_in_row))
				else:
					var current_container = flow.get_parent()
					var found_above = false
					for container in [$offensive_container, $defensive_container, $utility_container]:
						if container.visible and container.global_position.y < current_container.global_position.y:
							var above_flow = container.get_node("HFlowContainer")
							_focus_card(_get_closest_card(above_flow, card.global_position.x))
							found_above = true
							break
					if not found_above:
						get_node("../../../HFlowContainer").get_child(0).grab_focus()
			
			elif event.is_action_pressed("ui_down"):
				if card_index + cards_in_row < flow.get_child_count():
					_focus_card(flow.get_child(card_index + cards_in_row))
				else:
					var current_container = flow.get_parent()
					var found_below = false
					for container in [$offensive_container, $defensive_container, $utility_container]:
						if container.visible and container.global_position.y > current_container.global_position.y:
							var below_flow = container.get_node("HFlowContainer")
							_focus_card(_get_closest_card(below_flow, card.global_position.x))
							found_below = true
							break
			
			elif event.is_action_pressed("ui_left"):
				if card_index > 0:
					_focus_card(flow.get_child(card_index - 1))
			
			elif event.is_action_pressed("ui_right"):
				if card_index < flow.get_child_count() - 1:
					_focus_card(flow.get_child(card_index + 1))
		
		_nav_cooldown = true
		await get_tree().create_timer(0.2).timeout
		_nav_cooldown = false

func _on_item_fade_completed(card: MarginContainer) -> void:
	var button = card.get_node("PanelContainer/VBoxContainer/Button")
	button.focus_mode = Control.FOCUS_ALL
	button.grab_focus()

func _on_item_fade_back_completed(card: MarginContainer) -> void:
	var button = card.get_node("PanelContainer/VBoxContainer/Button")
	button.focus_mode = Control.FOCUS_NONE
	if card.visible:
		_focus_card(card)

func _on_card_focus_entered(card: MarginContainer) -> void:
	_focus_card(card)

func _get_closest_card(flow: Node, target_x: float) -> MarginContainer:
	var closest: MarginContainer = null
	var closest_dist = INF
	for child in flow.get_children():
		var dist = abs(child.global_position.x - target_x)
		if dist < closest_dist:
			closest_dist = dist
			closest = child
	return closest


func _grab_first_visible_focus() -> void:
	for container in [$offensive_container, $defensive_container, $utility_container]:
		if container.visible:
			var flow = container.get_node("HFlowContainer")
			if flow.get_child_count() > 0:
				_focus_card(flow.get_child(0))
				return
