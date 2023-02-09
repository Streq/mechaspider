extends Node
class_name State

signal finish(next_state, params)
signal push(next_state, params)
signal pop()
signal clear(next_state, params)
signal switch(next_state, params)

signal enter(params)
signal entered
signal exited
signal suspended
signal awakened
signal updated(delta)
signal physics_updated(delta)

var root

func enter(params):
	_enter(params)
	emit_signal("enter",params)
	emit_signal("entered")
func suspend():
	_suspend()
	emit_signal("suspended")
func awaken():
	_awaken()
	emit_signal("awakened")
func exit():
	_exit()
	emit_signal("exited")
func update(delta: float):
	_update(delta)
	emit_signal("updated", delta)
func physics_update(delta: float):
	_physics_update(delta)
	emit_signal("physics_updated", delta)

#OVERRIDABLE

# Initialize the state. E.g. change the animation
func _enter(params):
	return

# Clean up the state. Reinitialize values like a timer
func _exit():
	return
	
# Awake the state from suspension. E.g. Readd nodes to tree
func _awaken():
	return

# Suspend the state. E.g. Remove nodes
func _suspend():
	return

# Called during _process
func _update(delta: float):
	return

# Called during _physics_process
func _physics_update(delta: float):
	return

# Called during _input
func _handle_input(event: InputEvent):
	return


#UTILS

func goto(state: String):
	emit_signal("finish", state, null)

func goto_args(state: String, args: Array):
	emit_signal("finish", state, args)

func push(state: String):
	emit_signal("push", state, null)

func push_args(state: String, args: Array):
	emit_signal("push", state, args)

func switch(state: String):
	emit_signal("switch", state, null)

func switch_args(state: String, args: Array):
	emit_signal("switch", state, args)

func pop():
	emit_signal("pop")

func clear():
	emit_signal("clear")
