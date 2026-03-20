extends CharacterBody2D
signal health_changed

@onready var Sprite = $AnimatedSprite2D

@export var MAX_HP = 10.0
var hp = 0.0

var is_invinsible := false

func _ready() -> void:
	hp = MAX_HP

func on_hit(bullet):
	bullet.queue_free()
	
	if (!is_invinsible):
		Sprite.play("hurt")
		hp -= bullet.damage
		if (hp <= 0):	queue_free()
		is_invinsible = true
		
	health_changed.emit(hp/MAX_HP)

func on_animation_finished():
	Sprite.play("default")
	is_invinsible = false
