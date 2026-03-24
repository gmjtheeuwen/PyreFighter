class_name item_data
extends Resource

enum Type { OFFENSIVE, DEFENSIVE, UTILITY }

@export var id: String
@export var display_name: String
@export var type: Type
@export var icon: Texture2D
@export var description: String
@export var is_equipped: bool = false
@export var is_unlocked: bool = false
