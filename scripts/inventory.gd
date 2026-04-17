extends Node
class_name Inventory

signal equipped_item_changed(item: ItemData)
signal category_changed(category: String)

@export var CATEGORY: PackedScene
var INVENTORY_DATA = preload("res://resources/inventory/inventory.tres")

@onready var input_handler = $"../../InputHandler"
@onready var category_container = $HBoxContainer/ScrollContainer/VBoxContainer
@onready var limit_label = $HBoxContainer/MarginContainer/Control/limit_label
@onready var equipped_label = $HBoxContainer/MarginContainer/Control/equipped_label

var equipped_item: ItemData
var selected_category = ""
var categories: Dictionary[String, Category]

func _ready() -> void:
	for category in ItemData.Type.keys():
		if !categories.has(category):	
			var category_node = CATEGORY.instantiate()
			categories[category] = category_node
			category_node.name = "%s_container" % category
			category_container.add_child(category_node)
			
	
	for item in INVENTORY_DATA.items:
		var type = ItemData.Type.keys()[item.type]
		categories[type].add_item(item, on_item_equipped, input_handler.on_item_fade_end)

func _on_category_selected(category: String):	
	show_category(category)
	category_changed.emit(category)
	

func show_category(category_name: String) -> void:
	for container in category_container.get_children():
		if container.name.contains(category_name) || category_name == "":
			container.visible = true
		else:
			container.visible = false

func on_item_equipped(item: ItemData):
	if equipped_item == item:
		equipped_item = null
		limit_label.text = "equipment limit: 0/1"
		equipped_label.text = "currently equipped: \nnone "
	else:
		equipped_item = item
		limit_label.text = "equipment limit: 1/1"
		equipped_label.text = "currently equipped: \n%s " % item.display_name
