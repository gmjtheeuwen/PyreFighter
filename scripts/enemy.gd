extends CharacterBody2D

@onready var Sprite = $AnimatedSprite2D

func on_hit(bullet):
	Sprite.play("hurt")
	bullet.queue_free()

func on_animation_finished():
	Sprite.play("default")
