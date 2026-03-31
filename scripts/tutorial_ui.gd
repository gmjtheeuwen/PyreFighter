extends CanvasLayer

@export var tutorial_data: TutorialData
@export var next_scene: PackedScene

@onready var label = $Control/PanelContainer/MarginContainer/Label
@onready var timer = $Timer
@onready var animation = $AnimationPlayer

var current_index = 0
var accept_input = false

func _ready() -> void:
	if (tutorial_data):
		if tutorial_data.text:	
			label.text = tutorial_data.text[current_index]
			timer.start()
	else:
		animation.play("fade_out")

func _process(_delta: float) -> void:
	if !accept_input: return
	if !_check_input(): return
	
	accept_input = false
	current_index += 1
		
	if current_index == tutorial_data.text.size(): 
		animation.play("fade_out")
		timer.start(10)
	else:
		label.text = tutorial_data.text[current_index]
		timer.start()
		
func _check_input() -> bool:
	var input := tutorial_data.inputs[current_index]
	if !input.contains(','): return Input.is_action_pressed(input)
	
	var inputs = input.split(',')
	for i in inputs:
		if Input.is_action_pressed(i): return true
	
	return false

func _on_timeout():
	if current_index == tutorial_data.text.size(): get_tree().call_deferred("change_scene_to_packed", next_scene)
	else: accept_input = true
