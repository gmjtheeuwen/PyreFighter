extends Node2D

signal all_enemies_defeated
@export var disabled = false

@export var player: CharacterBody2D

var enemies: Array[Enemy]

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Enemy:
			enemies.append(child as Enemy)

func _process(_delta: float) -> void:
	if !player or disabled: return
	if enemies.size() == 0:
		all_enemies_defeated.emit()
		disabled = true
	for enemy in enemies:
		if enemy.is_knock_backed: continue
		
		enemy.velocity = (player.position - enemy.position).normalized() * enemy.cloned_stats.max_speed

func _disable():
	disabled = true
	
func _enable():
	disabled = false

func remove(enemy: Enemy):
	enemies.remove_at(enemies.find(enemy))
