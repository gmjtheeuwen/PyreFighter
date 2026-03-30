extends Node2D
class_name HealthComponent

signal health_changed(hp_ratio: float)
signal heatlh_depleted

@export var MAX_HEALTH := 10.0
var health: float

func _ready() -> void:
	health = MAX_HEALTH
	
func damage(damage_amount: float):
	health -= damage_amount
	
	if health <= 0:
		heatlh_depleted.emit()
	
	health_changed.emit(health/MAX_HEALTH)
