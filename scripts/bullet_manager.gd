extends Node2D

@onready var AmmoData = ammo_data

func _on_player_fired_bullet(bullet, bullet_position, bullet_direction, bullet_type, source):
	var config = AmmoData.get_config(bullet_type)
	
	bullet.position = bullet_position
	bullet.direction = _apply_spread(bullet_direction, config["spread"])
	bullet.speed = config["speed"]
	bullet.lifetime = config["lifetime"]
	bullet.source = source
	_spawn_projectiles(config["projectiles"], bullet, config["spread"])

func _apply_spread(direction: Vector2, spread_degrees: float):
	if spread_degrees == 0.0:
		return direction
	var spread_rad = deg_to_rad(randf_range(-spread_degrees, spread_degrees))
	return direction.rotated(spread_rad)

func _spawn_projectiles(projectiles: int, bullet, spread: float):
	for count in projectiles:
		var bullet_instance = bullet.duplicate()
		bullet_instance.position = bullet.position
		bullet_instance.direction = _apply_spread(bullet.direction, spread)
		bullet_instance.lifetime = bullet.lifetime
		bullet_instance.source = bullet.source
		bullet_instance.speed = bullet.speed
		bullet_instance.ammo_type = bullet.ammo_type
		add_child(bullet_instance)
