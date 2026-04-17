extends Resource
class_name Mission

@export var scene: StringName
@export var title: StringName
@export var description: StringName
@export_range(0, 3, 1) var difficulty: int = 0
@export var location: Vector2
@export var unlocks: Array[int]

var is_locked = true
var is_finished = false
