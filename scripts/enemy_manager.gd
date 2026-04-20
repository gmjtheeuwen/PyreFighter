extends Node2D

signal all_enemies_defeated
var disabled = false
@export var player: CharacterBody2D

func _process(_delta: float) -> void:
	if !player or disabled: return
	if get_children().size() == 0:
		disabled = true
		all_enemies_defeated.emit()
