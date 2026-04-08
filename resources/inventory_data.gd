class_name inventory_data
extends Resource

@export var items: Array[ItemData] = []
@export var unlocked_ammo: Dictionary[AttackComponent.AmmoType, bool]
@export var equipped_item: String = ""

func _init() -> void:
	for ammo in AttackComponent.AmmoType.values():
		unlocked_ammo[ammo] = false
	unlocked_ammo[AttackComponent.AmmoType.WATER] = true
