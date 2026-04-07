extends Resource
class_name EnemyStats

@export var type: String = ""
@export var max_health: float
@export var max_speed: float
@export var knockback_friction: float
@export var sprite_sheet: CompressedTexture2D
@export var effects: Array[Effect]

func resolve_effects(ammo_type: AttackComponent.AmmoType, attacker: Player, target: Enemy):
	for effect in effects:
		effect.resolve(ammo_type, attacker, target)
