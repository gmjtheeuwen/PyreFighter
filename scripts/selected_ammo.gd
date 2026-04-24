class_name selected_ammo
extends Control

var ammo_list = preload("res://scripts/components/attack_component.gd")
var images: Array[Resource]

@onready var texture = $Panel/TextureRect
@onready var label = $Panel/AmmoName

func _ready():
	images = [load("res://assets/ammo_types/water.png"), load("res://assets/ammo_types/foam.png"), load("res://assets/ammo_types/powder.png"),load("res://assets/ammo_types/carbondioxide.png")]

func _on_player_ammo_changed(ammo_type: AttackComponent.AmmoType) -> void:
	if ammo_type == 0:
		ammo_type = 1
	
	texture.texture = images[ammo_type - 1]
	label.text = str(AttackComponent.AmmoType.keys()[ammo_type]).to_lower()
