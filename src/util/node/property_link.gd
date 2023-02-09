extends Node

export var source_node : NodePath
export var source_property : String
export var dest_node : NodePath
export var dest_property : String

onready var source = get_node(source_node)
onready var source_path = NodePath(source_property)
onready var dest = get_node(dest_node)
onready var dest_path = NodePath(dest_property)


func trigger():
	dest.set_indexed(dest_path, source.get_indexed(source_path))
