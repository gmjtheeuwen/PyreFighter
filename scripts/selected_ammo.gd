class_name selected_ammo
extends TextureRect

var ammo_list = preload("res://scripts/components/attack_component.gd")

func _on_player_ammo_changed(ammo_type: AttackComponent.AmmoType) -> void:
	if ammo_type == AttackComponent.AmmoType.WATER:
		var image = load("res://assets/ammo type water.png")
		$".".texture = image 
	elif ammo_type == AttackComponent.AmmoType.FOAM:
		var image = load("res://assets/ammo type foam.png")
		$".".texture = image 
	elif ammo_type == AttackComponent.AmmoType.CARBONDIOXIDE:
		var image = load("res://assets/ammo type carbondioxide.png")
		$".".texture = image 
	elif ammo_type == AttackComponent.AmmoType.POWDER:
		var image = load("res://assets/ammo type powder.png")
		$".".texture = image 
