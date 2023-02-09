extends Node

func trigger():
	var node = get_parent()
	var parent = node.get_parent()
	var grandparent = parent.get_parent()
	parent.remove_child(node)
	grandparent.add_child(node)
	if "transform" in node and "transform" in parent:
		node.transform *= parent.transform
