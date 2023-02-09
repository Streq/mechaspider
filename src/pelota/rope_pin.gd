extends Node2D
class_name RopePin

export (int, -1, 1, 2) var side_of_pin := -1
export var rope_path : NodePath
onready var rope: Rope = get_node(rope_path)


func _physics_process(delta: float) -> void:
	rope.step(global_position, side_of_pin)

func get_pull_direction():
	var start_index = min(side_of_pin, 0)
	var end = rope.line_points[start_index]
	var origin = rope.line_points[start_index+side_of_pin]
	return end.direction_to(origin)

func reset_rope_position_to_self():
	rope.line_points = PoolVector2Array([global_position, global_position])
