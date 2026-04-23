extends Node

var inventory_data = preload("res://resources/inventory/inventory.tres")

func _unlock_ammo(ammo: AttackComponent.AmmoType):
	inventory_data.unlocked_ammo[ammo] = true

func _unlock_equipment():
	pass
