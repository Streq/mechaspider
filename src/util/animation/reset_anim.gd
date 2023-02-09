extends Node

func trigger():
	get_parent().play("RESET")
	get_parent().advance(0.0)
