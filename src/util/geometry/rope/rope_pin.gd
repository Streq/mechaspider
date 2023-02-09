extends Node2D


export var index_of_pinned_point := -1
export var rope_path : NodePath
onready var rope = get_node(rope_path)


func _physics_process(delta: float) -> void:
	rope.step(global_position, index_of_pinned_point)
	var start = min(index_of_pinned_point, 0)
	var pull_direction = rope.line_points[start].direction_to(
			rope.line_points[start+index_of_pinned_point]
		)

	get_parent().apply_central_impulse(pull_direction*1000.0*delta)
