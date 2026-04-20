class_name ammo_data
extends Node

const AMMO_CONFIG = {
	AttackComponent.AmmoType.WATER: {"spread": 0.0, "lifetime": 3.0, "projectiles": 1.0, "speed": 800, "friction": 0.8},
	AttackComponent.AmmoType.FOAM: {"spread": 7.5, "lifetime": 0.7, "projectiles": 2.0, "speed": 800,"friction": 3},
	AttackComponent.AmmoType.POWDER: {"spread": 5.0, "lifetime": 1.0, "projectiles": 2.0, "speed": 800, "friction": 2.0},
	AttackComponent.AmmoType.CARBONDIOXIDE: {"spread": 15.0, "lifetime": 0.5, "projectiles": 4.0, "speed": 800, "friction": 3.0}
	}

static func get_config(ammo_type) -> Dictionary:
	return AMMO_CONFIG.get(ammo_type, { "spread": 0.0, "lifetime": 2.0 })
