extends HFlowContainer
class_name sorting_buttons
signal selected_category_changed(new_category: String)

@export var category_button: PackedScene
var selected_category = ""

func _ready() -> void:
	var all_button = category_button.instantiate()
	all_button.name = "All"
	all_button.text = "Show All"
	all_button.pressed.connect(_select_category.bind(""))
	add_child(all_button)
	for type in ItemData.Type.keys():
		var button = category_button.instantiate()
		button.name = type
		button.text = "Show %s" % type
		button.pressed.connect(_select_category.bind(type))
		add_child(button)

func _select_category(category: String):
	if selected_category != category:
		selected_category = category
		selected_category_changed.emit(category)
