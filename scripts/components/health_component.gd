extends Node2D
class_name HealthComponent

signal health_changed(hp_ratio: float)
signal heatlh_depleted

@export var max_health := 10.0
var health: float

func _ready() -> void:
	health = max_health
	
func damage(damage_amount: float):
	health -= damage_amount
	print(health)
	
	if health <= 0:
		heatlh_depleted.emit()
	
	health_changed.emit(health/max_health)
