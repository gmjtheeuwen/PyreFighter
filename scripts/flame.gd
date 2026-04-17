extends Node2D
class_name Flame

enum FuelType{
	SOLID,
	LIQUID,
	GAS,
	ELECTRIC
}

var spawn_delay := 10.0
var fuel_type: FuelType = FuelType.SOLID

@onready var health_component = $HealthComponent

func _on_hit(attack: AttackComponent):
	if attack.attack_type == AttackComponent.AmmoType.NONE: return
	health_component.damage(attack.damage)

func _on_health_changed(hp_ratio: float):
	scale = Vector2(hp_ratio/2+ 0.5, hp_ratio/2 + 0.5)

func _on_health_depleted():
	queue_free()
