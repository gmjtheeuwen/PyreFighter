extends VBoxContainer
class_name Category

const ITEM_CARD = preload("res://scenes/item.tscn")

@onready var flow = $HFlowContainer
@onready var title = $Title

func _ready() -> void:
	title.text = name.trim_suffix("_container")

func add_item(item: ItemData, equip_item: Callable):
	var card = ITEM_CARD.instantiate()
	card.setup(item)
	card.equip_button_pressed.connect(equip_item)
	flow.add_child(card)
