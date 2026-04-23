class_name selected_ammo
extends Control

var ammo_list = preload("res://scripts/components/attack_component.gd")

var images: Dictionary[String, Resource]

@onready var texture = $Panel/TextureRect
@onready var label = $Panel/AmmoName

func _ready():
	for file_name in DirAccess.get_files_at("res://assets/ammo_types"):
		if file_name.ends_with(".png"):
			images[file_name.trim_suffix(".png")] = load("res://assets/ammo_types/%s" % file_name)

func _on_player_ammo_changed(ammo_type: AttackComponent.AmmoType) -> void:
	var ammo_name = str(AttackComponent.AmmoType.keys()[ammo_type]).to_lower()
	if ammo_type == 0:
		ammo_name = "water"
	
	texture.texture = images[ammo_name]
	label.text = ammo_name
