extends Node
class_name InputHandler

var _nav_cooldown := false
var _current_sort_index = 0

@onready var inventory: Inventory = $"../VBoxContainer/inventory_list"
@onready var category_container = $"../VBoxContainer/inventory_list/HBoxContainer/ScrollContainer/VBoxContainer"
@onready var sorting_container: sorting_buttons = $"../VBoxContainer/HFlowContainer"
@onready var button_selected_stylebox: StyleBoxFlat = preload("res://resources/styles/button_selected.tres")
@onready var button_unselected_stylebox: StyleBoxFlat = preload("res://resources/styles/button_unselected.tres")

func _ready():
	_grab_first_visible_focus()
	sorting_container.get_child(0).add_theme_stylebox_override("normal", button_selected_stylebox)

func _input(event: InputEvent) -> void:
		
	var focused = get_viewport().gui_get_focus_owner()
	
	if event.is_action_pressed("ui_page_left") or event.is_action_pressed("ui_page_right"):
		_handle_sort_navigation(event)
		_update_sort_buttons()
		get_viewport().set_input_as_handled()
		return
	
	if _is_directional(event) and _is_equip_button(focused):
		if _nav_cooldown:
			get_viewport().set_input_as_handled()
			return
		_handle_directional(event, focused)
		_nav_cooldown = true
		await get_tree().create_timer(0.2).timeout
		_nav_cooldown = false
		
func on_item_fade_end(item: Item):
	var button = item.get_node("PanelContainer/VBoxContainer/Button")
	button.focus_mode = Control.FOCUS_ALL
	button.grab_focus()

func _is_equip_button(node: Node) -> bool:
	return node and node is Button and \
		node.get_parent().get_parent().get_parent() is Item

func _is_directional(event: InputEvent) -> bool:
	return event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or \
		event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right")

func _handle_directional(event: InputEvent, focused: Node) -> void:
	get_viewport().set_input_as_handled()
	var card = focused.get_parent().get_parent().get_parent() as Item
	var flow = card.get_parent()
	var card_index = card.get_index()
	var category_index = flow.get_parent().get_index()
	
	if event.is_action_pressed("ui_up"):
		_navigate(category_index - 1, card_index)
		#_navigate_up(card, flow, card_index, cards_in_row)
	elif event.is_action_pressed("ui_down"):
		#_navigate_down(card, flow, card_index, cards_in_row)
		_navigate(category_index + 1, card_index)
	elif event.is_action_pressed("ui_left") and card_index > 0:
		#flow.get_child(card_index - 1).grab_focus()
		_navigate(category_index, wrapi(card_index-1, 0, flow.get_children().size()))
	elif event.is_action_pressed("ui_right") and card_index < flow.get_child_count() - 1:
		#flow.get_child(card_index + 1).grab_focus()
		_navigate(category_index, wrapi(card_index+1, 0, flow.get_children().size()))
	
func _navigate(category_index: int, card_index: int):
	var categories = category_container.get_children()
	if category_index < 0 || category_index >= categories.size(): 
		_focus_sort_buttons()
		return
	
	var category = categories[category_index]
	if !category.visible: return
	
	category.get_child(1).get_child(card_index).grab_focus()
	
func _on_category_changed(category: String):
	_grab_first_visible_focus()

func _get_visible_categories() -> Array:
	return inventory.category_container.get_children().filter(func(c): return c.visible)

func _focus_sort_buttons() -> void:
	if sorting_container and sorting_container.get_child_count() > 0:
		sorting_container.get_child(0).grab_focus()

func _grab_first_visible_focus() -> void:
	for category in _get_visible_categories():
		if category.flow.get_child_count() > 0:
			category.flow.get_child(0).grab_focus()
			return

func on_card_focus_entered(card: Item) -> void:
	var texture_rect = card.get_node("PanelContainer/TextureRect")
	var button = card.get_node("PanelContainer/VBoxContainer/Button")
	if not texture_rect.visible:
		button.focus_mode = Control.FOCUS_ALL
		button.grab_focus()
	else:
		button.focus_mode = Control.FOCUS_NONE

func _handle_sort_navigation(event: InputEvent) -> void:
	if event.is_action_pressed("ui_page_left"):
		_current_sort_index = wrap(_current_sort_index - 1, 0, sorting_container.get_child_count())
	elif event.is_action_pressed("ui_page_right"):
		_current_sort_index = wrap(_current_sort_index + 1, 0, sorting_container.get_child_count())
		
func _update_sort_buttons():
	for c in sorting_container.get_children():
		var button = c as Button
		if (button.get_index() != _current_sort_index):	button.add_theme_stylebox_override("normal", button_unselected_stylebox)
		else:
			button.add_theme_stylebox_override("normal", button_selected_stylebox)
			sorting_container.get_child(_current_sort_index).emit_signal("pressed")
