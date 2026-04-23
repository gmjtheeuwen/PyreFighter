extends Node2D
class_name AttackComponent

enum AmmoType{
	NONE,
	WATER,
	FOAM,
	POWDER,
	CARBONDIOXIDE
}

var damage: float
var knockback: float
var direction := Vector2.ZERO
var source: Node2D
var attack_type: AmmoType
