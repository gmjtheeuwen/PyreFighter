extends Node2D
class_name AttackComponent

enum AmmoType{
	NONE,
	WATER,
	FOAM,
	POWDER,
	CARBONDIOXIDE
}

@export var damage: float
@export var knockback: float
var source: Node2D

@export var attack_type: AmmoType
