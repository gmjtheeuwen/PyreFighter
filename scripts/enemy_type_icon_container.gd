extends HBoxContainer
class_name EnemyTypeIconContainer

var icon_scene = preload("res://scenes/enemy_type_icon.tscn")
var enemy_types: Array[Flame.FuelType]
	
func _ready() -> void:
	update_enemy_types(enemy_types)

func get_texture(type: Flame.FuelType) -> Resource:
	var texture_name = "res://assets/icons/Icon%s.png" % str(Flame.FuelType.keys()[type]).capitalize()
	return load(texture_name)

func update_enemy_types(new_enemy_types: Array[Flame.FuelType]):
	for type in enemy_types:
		if (get_child_count() > 0):
			remove_child(get_child(0))
		
	enemy_types = new_enemy_types.duplicate()
	
	for type in range(Flame.FuelType.values().size()):
		if enemy_types.has(type):
			var icon: TextureRect = icon_scene.instantiate()
			icon.texture = get_texture(type)
			add_child(icon)
