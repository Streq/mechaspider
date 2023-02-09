extends Node

func get_all(group: String) -> Array:
	return get_tree().get_nodes_in_group(group)

func get_one(group: String) -> Node:
	if get_tree().has_group(group):
		return get_tree().get_nodes_in_group(group)[0]
	else:
		return null

func exists(group: String) -> bool:
	return get_tree().has_group(group)
