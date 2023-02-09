extends Node

export (Array, PackedScene) var level_circuit = []
var current_level_index := 0

func start_current_level():
	get_tree().change_scene_to(level_circuit[current_level_index])

func next():
	set_current_level_index(current_level_index+1)
	start_current_level()

func set_current_level_index(val):
	current_level_index = posmod(val, level_circuit.size())
