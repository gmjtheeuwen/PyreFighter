extends Node2D

signal all_enemies_defeated
var disabled = false

func _process(_delta: float) -> void:
	if disabled: return
	if get_children().size() == 0:
		disabled = true
		all_enemies_defeated.emit()
