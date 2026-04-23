extends Node2D
class_name Flame

enum FuelType{
	SOLID,
	LIQUID,
	GAS,
	ELECTRIC
}

@export var fuel_type: FuelType = FuelType.SOLID
@export var max_hp := 10.0

@onready var sprite = $AnimatedSprite2D
@onready var health_component = $HealthComponent

func _ready() -> void:
	var anim_name = str(FuelType.keys()[fuel_type]).to_lower()
	sprite.play(anim_name)
	health_component.health = max_hp
	health_component.max_health = max_hp

func _on_hit(attack: AttackComponent):
	if attack.attack_type == AttackComponent.AmmoType.NONE: return
	health_component.damage(attack.damage)

func _on_health_changed(hp_ratio: float):
	scale = Vector2(hp_ratio/2+ 0.5, hp_ratio/2 + 0.5)

func _on_health_depleted():
	queue_free()
