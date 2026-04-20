extends Node
class_name StateMachine

@export var initial_state: State = null
var state: State

func _ready() -> void:
	state = initial_state if initial_state != null else get_child(0)
	
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_change_state)
	
	await owner.ready
	state.enter({})
	
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)
	
func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func _change_state(new_state: String, data := {}):
	if not has_node(new_state): return
	
	state.exit()
	state = get_node(new_state)
	state.enter(data)
