extends AttackComponent
class_name FireParticle

var speed: float
var range: float
var origin: Vector2

var flame_scene = preload("res://scenes/flame.tscn")
var fuel_type: Flame.FuelType

func _ready() -> void:
	global_position = origin

func _process(delta: float) -> void:
	global_position += speed * direction * delta
	
	if (global_position - origin).length() > range:
		queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("environment"):
		var tilemap = body as TileMapLayer
		var cell := tilemap.local_to_map(global_position/tilemap.global_scale)
		var data: TileData = tilemap.get_cell_tile_data(cell)
		
		if data: 
			var flammable: bool = data.get_custom_data("flammable")
			if flammable: _on_flammable_hit(global_position)
				
	elif body.is_in_group("player"):
		body.on_hit(self)
		queue_free()

func _on_flammable_hit(hit_position: Vector2):
	var flame: Flame = flame_scene.instantiate()
	flame.fuel_type = fuel_type
	flame.global_position = hit_position
	get_tree().current_scene.call_deferred("add_child", flame)
