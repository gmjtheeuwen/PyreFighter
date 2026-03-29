extends Node
class_name InputHandler

var _nav_cooldown := false
var _using_controller := false

@onready var inventory: Inventory = get_parent().get_node("VBoxContainer/inventory_list")
@onready var sorting_container: sorting_buttons = get_parent().get_node("VBoxContainer/HFlowContainer")

func _input(event: InputEvent) -> void:
	_detect_input_method(event)
	
	if event.is_action_pressed("ui_page_left") or event.is_action_pressed("ui_page_right"):
		_handle_sort_navigation(event)
		get_viewport().set_input_as_handled()
		return
	
	var focused = get_viewport().gui_get_focus_owner()
	var is_equip_button = _is_equip_button(focused)
	
	if focused is Item:
		await focused.fade_animation.animation_finished
		var button = focused.get_node("PanelContainer/VBoxContainer/Button")
		button.focus_mode = Control.FOCUS_ALL
		button.grab_focus()
		get_viewport().set_input_as_handled()
	
	elif event.is_action_pressed("ui_cancel") and is_equip_button:
		var card = focused.get_parent().get_parent().get_parent()
		card.grab_focus()
		get_viewport().set_input_as_handled()
	
	elif _is_directional(event) and is_equip_button:
		if _nav_cooldown:
			get_viewport().set_input_as_handled()
			return
		_handle_directional(event, focused)
		_nav_cooldown = true
		await get_tree().create_timer(0.2).timeout
		_nav_cooldown = false

func _detect_input_method(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if not _using_controller:
			_using_controller = true
			_grab_first_visible_focus()
	elif event is InputEventMouseButton or event is InputEventMouseMotion or event is InputEventKey:
		_using_controller = false

func _is_equip_button(node: Node) -> bool:
	return node and node is Button and \
		node.get_parent().get_parent().get_parent() is Item

func _is_directional(event: InputEvent) -> bool:
	return event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or \
		event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right")

func _handle_directional(event: InputEvent, focused: Node) -> void:
	get_viewport().set_input_as_handled()
	var card = focused.get_parent().get_parent().get_parent()
	var flow = card.get_parent()
	var card_index = card.get_index()
	var cards_in_row = _count_cards_in_row(flow, card)
	
	if event.is_action_pressed("ui_up"):
		_navigate_up(card, flow, card_index, cards_in_row)
	elif event.is_action_pressed("ui_down"):
		_navigate_down(card, flow, card_index, cards_in_row)
	elif event.is_action_pressed("ui_left") and card_index > 0:
		flow.get_child(card_index - 1).grab_focus()
	elif event.is_action_pressed("ui_right") and card_index < flow.get_child_count() - 1:
		flow.get_child(card_index + 1).grab_focus()

func _count_cards_in_row(flow: Node, card: Item) -> int:
	var count = 0
	for child in flow.get_children():
		if child.global_position.y == card.global_position.y:
			count += 1
	return count

func _navigate_up(card: Item, flow: Node, card_index: int, cards_in_row: int) -> void:
	if card_index >= cards_in_row:
		flow.get_child(card_index - cards_in_row).grab_focus()
		return
	for category in _get_visible_categories():
		if category.global_position.y < flow.get_parent().global_position.y:
			_get_closest_card(category.flow, card.global_position.x).grab_focus()
			return
	_focus_sort_buttons()

func _navigate_down(card: Item, flow: Node, card_index: int, cards_in_row: int) -> void:
	if card_index + cards_in_row < flow.get_child_count():
		flow.get_child(card_index + cards_in_row).grab_focus()
		return
	for category in _get_visible_categories():
		if category.global_position.y > flow.get_parent().global_position.y:
			_get_closest_card(category.flow, card.global_position.x).grab_focus()
			return

func _get_visible_categories() -> Array:
	return inventory.category_container.get_children().filter(func(c): return c.visible)

func _focus_sort_buttons() -> void:
	var sort_container = _get_sort_container()
	if sort_container and sort_container.get_child_count() > 0:
		sort_container.get_child(0).grab_focus()

func _grab_first_visible_focus() -> void:
	for category in _get_visible_categories():
		if category.flow.get_child_count() > 0:
			category.flow.get_child(0).grab_focus()
			return

func _get_closest_card(flow: Node, target_x: float) -> Item:
	var closest: Item = null
	var closest_dist = INF
	for child in flow.get_children():
		var dist = abs(child.global_position.x - target_x)
		if dist < closest_dist:
			closest_dist = dist
			closest = child
	return closest

func on_card_focus_entered(card: Item) -> void:
	var texture_rect = card.get_node("PanelContainer/TextureRect")
	var button = card.get_node("PanelContainer/VBoxContainer/Button")
	if not texture_rect.visible:
		button.focus_mode = Control.FOCUS_ALL
		button.grab_focus()
	else:
		button.focus_mode = Control.FOCUS_NONE

func _handle_sort_navigation(event: InputEvent) -> void:
	var sort_container = _get_sort_container()
	var current_index = 0
	for i in sort_container.get_child_count():
		if sort_container.get_child(i).has_focus():
			current_index = i
			break
	if event.is_action_pressed("ui_page_left"):
		current_index = max(0, current_index - 1)
	elif event.is_action_pressed("ui_page_right"):
		current_index = min(sort_container.get_child_count() - 1, current_index + 1)
	sort_container.get_child(current_index).grab_focus()
	sort_container.get_child(current_index).emit_signal("pressed")

func _get_sort_container() -> HFlowContainer:
	return sorting_container
