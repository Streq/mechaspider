extends Node

export (NodePath) onready var polygon = get_node(polygon)


func _ready() -> void:
	get_parent().global_transform = polygon.global_transform
	get_parent().polygon = polygon.polygon
