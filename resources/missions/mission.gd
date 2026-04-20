extends Resource
class_name Mission

@export var scene: StringName
@export var title: StringName
@export var description: StringName
@export var experience: int = 0
@export var is_locked = false
var is_finished = false

@export var enemy_types: Array[Flame.FuelType]
@export_range(0, 3, 1) var difficulty: int = 0
@export var location: Vector2
@export var player_hub_position: Hub.Position
@export var unlocks: Array[int]
