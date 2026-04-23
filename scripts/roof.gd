extends Node2D

@onready var tilemap = $TileMapOutside
var default_color: Color

func _ready() -> void:
	default_color = tilemap.self_modulate

func _on_body_entered(body: Node2D):
	if (body.is_in_group("player")):
		tilemap.self_modulate = Color(1, 1, 1, 0.2)
		
func _on_body_exited(body: Node2D):
	if (body.is_in_group("player")):
		tilemap.self_modulate = default_color

func _on_area_entered(area: Area2D):
	var body = area.get_parent()
	_on_body_entered(body)

func _on_area_exited(area: Area2D):
	var body = area.get_parent()
	_on_body_exited(body)
