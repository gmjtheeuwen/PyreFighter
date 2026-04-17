extends Area2D
signal interacted

var player: Node2D = null
@onready var label = $Label

@export var START_TEXT = "FINISH"
@export var INTERACTION_TEXT = "Player interacted"

@export var disabled = false

func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player = body

func on_body_exited(body: Node2D):
	if body == player:
		player = null

func toggle():
	disabled = !disabled

func _process(_delta: float) -> void:
	if player == null or disabled: 
		label.visible = false
		return
	label.visible = true
	
	if Input.is_action_just_pressed("interact"):
		label.visible = false
		interacted.emit()
