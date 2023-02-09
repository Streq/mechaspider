extends Node
class_name StackFiniteStateMachine
signal state_changed(state)

export (String) var start_state

var stack: Array = []
var queue: Array = []
var states:= {}
var NULL_STATE := State.new()
var current : State = NULL_STATE


func initialize():
	for state in get_children():
		states[state.name] = state
		state.connect("finish", self, "_change_state")
		state.connect("push", self, "push_state")
		state.connect("pop", self, "pop_state")
		state.connect("clear", self, "clear")
		state.connect("switch", self, "change_state")
	stack.append(states[start_state])
	current = stack[-1]
	current.enter(null)

func physics_update(delta: float):
	for state in stack:
		if state.physics_update(delta):
			break

func update(delta: float):
	for state in stack:
		if state.update(delta):
			break

func handle_input(event: InputEvent):
	stack[-1]._handle_input(event)



enum Action{
	SWITCH,
	PUSH,
	POP,
	CLEAR
}

func _process_queue():
	for op in queue:
		match op.action:
			Action.SWITCH:
				_change_state(op.name,op.params)
			Action.PUSH:
				_push_state(op.name,op.params)
			Action.POP:
				_pop_state()
			Action.CLEAR:
				_clear()
	queue.clear()

func push_state(state_name: String, params):
	queue.push_back({
		"action": Action.PUSH, 
		"name": state_name, 
		"params": params
	})
func pop_state():
	queue.push_back({"action":Action.POP})
func change_state(state_name: String, params):
	queue.push_back({
		"action":Action.SWITCH,
		"name": state_name,
		"params": params
	})
func clear():
	queue.push_back({"action":Action.CLEAR})

func _push_state(state_name: String, params):
	current.suspend()
	stack.push_back(states[state_name])
	current = stack[-1]
	current.enter(params)

func _pop_state():
	current.exit()
	stack.pop_back()
	current = stack[-1]
	current.awaken()

func _change_state(state_name: String, params):
	current.exit()
	stack[-1] = states[state_name]
	current = stack[-1]
	current.enter(params)
	emit_signal("state_changed", state_name)

func _clear():
	queue.push_back({"action":"clear"})
