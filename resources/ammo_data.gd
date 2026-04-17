class_name ammo_data
extends Node

const AMMO_CONFIG = {
	AttackComponent.AmmoType.WATER: {"spread": 0.0, "lifetime": 3.0, "projectiles": 1.0, "speed": 800},
	AttackComponent.AmmoType.FOAM: {"spread": 7.5, "lifetime": 0.7, "projectiles": 2.0, "speed": 280},
	AttackComponent.AmmoType.POWDER: {"spread": 10.0, "lifetime": 1.5, "projectiles": 3.0, "speed": 240},
	AttackComponent.AmmoType.CARBONDIOXIDE: {"spread": 15.0, "lifetime": 0.5, "projectiles": 4.0, "speed": 200}
	}

static func get_config(ammo_type) -> Dictionary:
	return AMMO_CONFIG.get(ammo_type, { "spread": 0.0, "lifetime": 2.0 })
