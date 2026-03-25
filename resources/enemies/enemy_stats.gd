extends Resource
class_name EnemyStats

@export var type: String = ""
@export var max_health: float
@export var max_speed: float
@export var knockback_friction: float
@export var sprite_sheet: CompressedTexture2D


func resolve_effects(ammo_type: AttackComponent.AmmoType, attacker:Player, target: Enemy):
	pass
