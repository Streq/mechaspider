extends Node2D

export var rope_path: NodePath 
onready var rope: Rope = get_node(rope_path)

onready var links: Node2D = $links
onready var path_2d: Path2D = $Path2D
onready var curve: Curve2D= path_2d.curve
onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D


func _process(delta: float) -> void:
	curve.clear_points()
	for point in rope.line_points:
		curve.add_point(point)
	
	var i = 0.0
	var size = links.get_child_count()

	for child in links.get_children():
		path_follow_2d.unit_offset = i/size
#		print(path_follow_2d.offset)
		child.global_position = path_follow_2d.global_position
		child.global_rotation = 0
		i+=1.0
#
#
#	var i = 0
#	var size = links.get_child_count()
#
#	var start_pos = owner.global_position
##	if !is_instance_valid(owner.wearer):
##		return
#	var end_pos = owner.wearer.global_position
#	var distance_vector = end_pos-start_pos
#
#	for child in links.get_children():
#		child.global_position = start_pos+(distance_vector/size)*i
#		child.global_rotation = 0
#		i+=1
#
