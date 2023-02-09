extends Node2D
class_name Rope
signal step_begin()
signal split(point)
signal join(point)
signal scanned_points(points)
signal check(O, A, B)
signal updated(points)
signal step_end()

"""
Bueno, la lógica en principio es como en both_sides_rope_sweep.gd:

CASO 1
MUEVO LA SOGA SIN ENROSCAR

-cuando muevo ambos extremos de la soga, se forma un cuadrilatero (par de triangulos si es cruzado)
-se buscan colisiones en esa área
-para cada punto de la colisión, se busca si está dentro del área
-se ordenan los puntos por orden de chocada
-el primer punto con el que se choca divide la soga en los dos extremos y el nuevo punto enroscado
-se continua analizando cada extremo como movimiento triangular


CASO 2
MUEVO LA SOGA ESTANDO ENROSCADA
-se analiza el movimiento de un extremo, despues el otro, siguiendo el algoritmo de punto fijo
-si la soga se desenrosca cuando uno de los 2 se esta moviendo y falta el otro, se sigue igual
-es decir, cuando finaliza el movimiento triangular de un extremo, inicia el triangular del otro

"""

var line_points := PoolVector2Array([Vector2(), Vector2()])
var current_step_joins = [[],[]]
var active = true

func enable():
	active = true
func disable():
	active = false

func _ready() -> void:
	emit_signal("updated",line_points)

func double_step(B0:Vector2, B1:Vector2):
	if !active:
		line_points[0] = B0
		line_points[-1] = B1
		return
	emit_signal("step_begin")
	clear_caches()
	
	
	var B0_moved = B0 != line_points[0]
	var B1_moved = B1 != line_points[-1]
	
	
	if B0_moved and B1_moved:
#		if line_points.size()==2:
#			solve_cuadrilateral_step(B0,B1)
#		else:
		single_step(B0, 1)
		single_step(B1, -1)
	elif B0_moved:
		single_step(B0, 1)
	elif B1_moved:
		single_step(B1, -1)
	
	emit_signal("updated",line_points)
	emit_signal("step_end")
	
func step(B:Vector2, increment):
	var start = min(increment,0)
	emit_signal("step_begin")
	clear_caches()
	
	var B_moved = B != line_points[start]
	if B_moved:
		single_step(B, increment)
	
	emit_signal("updated",line_points)
	emit_signal("step_end")


func solve_cuadrilateral_step(B0:Vector2,B1:Vector2):
	pass

var latest_non_zero_side_of_swing := [0.0,0.0]

func single_step(B:Vector2, increment:int) -> bool:
	var start = min(increment, 0)
	if !active:
		line_points[start] = B
		return false
	var O = line_points[start+increment]
	var A = line_points[start] #rope pre swing position
	line_points[start] = B
	#       .O
	#	   / \
	#	  /   \
	#	 /     \
	#	/       \
	#  .A        .B
	
	while true:
		if A==B:
			return false
		O = line_points[start+increment] #rope latest split position (or rope origin if no splits)
		
		emit_signal("check",O,A,B)
		if line_points.size()>=3:
			#rope previous split position
			var Q := line_points[start+increment*2]
			
			#intersection between QO's line and AB
			#U is null if no intersection or same line
			var U = Geometry.line_intersects_line_2d(Q,O-Q,A,B-A)
			var parallel_swing = U == null
			var A_is_right_at_the_middle = Geometry.line_intersects_line_2d(O,A-O,Q,O-Q) == null
			var current_side_of_swing = RopeUtils.get_side_of_swing(Q,O,A)
			if current_side_of_swing:
				latest_non_zero_side_of_swing[start] = current_side_of_swing
			if parallel_swing and A_is_right_at_the_middle:
				#       .Q
				#       |
				#       |
				#       .O
				#	    |
				#	    .A
				#	    |   AB is in the same line as QO
				#	    |
				#       .B
				return true
			elif RopeUtils.is_swing_from_side_to_middle(Q,O,A,B):
				#       .Q
				#       |
				#       |
				#       .O
				#	   /|
				#	  / |
				#	 /  |
				#	/   |
				#  .A   .B
				
				
				if check_splits(A,B,start,increment):
					Q = line_points[start+increment*2]
					O = line_points[start+increment]
					latest_non_zero_side_of_swing[start] = RopeUtils.get_side_of_full_swing(Q,O,A,B)
				
				return true
			elif RopeUtils.is_swing_from_middle_to_side(Q,O,A,B):
				#       .Q
				#       |
				#       |
				#       .O
				#	    |\
				#	    | \
				#	    |  \
				#	    |   \
				#       .A   .B
				if latest_non_zero_side_of_swing[start] != RopeUtils.get_side_of_swing(Q,O,B):
					current_step_joins[start].append(O)
					join_point(start+increment)
					continue
				
				return true
			elif RopeUtils.is_swing_from_side_to_side(Q,O,A,B):
				#       .Q
				#       |
				#       |
				#       .O
				#	   /.\
				#	  / . \
				#	 /  .  \
				#	/   .   \
				#  .A   .U   .B
				if !check_splits(A,U,start,increment):
					current_step_joins[start].append(O)
					join_point(start+increment)
					A = U
					continue
				check_splits(U,B,start,increment)
				return true
			else:
				#.Q_____.O..............(U isn't inside AB)
				#	   / \
				#	  /   \
				#	 /     \
				#	/       \
				#  .A        .B
				check_splits(A,B,start,increment)
				return true
		else:
			#       .O
			#	   / \
			#	  /   \
			#	 /     \
			#	/       \
			#  .A        .B
			if check_splits(A,B,start,increment):
				var Q = line_points[start+increment*2]
				O = line_points[start+increment]
				latest_non_zero_side_of_swing[start] = RopeUtils.get_side_of_full_swing(Q,O,A,B)
			return true
			
		
	return true



func check_splits(A:Vector2,B:Vector2, start:int, increment:int):
	var O :Vector2 = line_points[start+increment]
#	draw_triangles.append(PoolVector2Array([O,A,B]))
	
	var points_in_triangle = RopeUtils.get_all_collider_points_inside_triangle(
			get_world_2d().direct_space_state, 
			O,A,B
		)
	
	if points_in_triangle.empty():
		return false
	
	if points_in_triangle.size()==1:
		var point = points_in_triangle[0]
		var valid = check_single_split(point, start, increment)
		if valid:
			split(point,increment)
		return valid
		
	var comparator = PointComparatorByAngleWithSegment.new(O,A)
	points_in_triangle.sort_custom(comparator, "compare_points_asc")
	
	emit_signal("scanned_points",points_in_triangle)
	
	var current_square_dist = 0
	var at_least_one_split = false
	for p in points_in_triangle:
#		draw_collided_points.append(p)
		var point :Vector2 = p
#		draw_internal_triangles.append(PoolVector2Array([A,B,line_points[-2]]))
		if (
			RopeUtils.point_is_inside_triangle_inclusive_but_exclude_first_segment(p,line_points[start+increment],A,B)
			and check_single_split(point,start,increment)
		):
			split(point,increment)
			emit_signal("check",A,B,line_points[start+increment])
			at_least_one_split = true
	
	return at_least_one_split


func check_single_split(at,start,increment):
	var valid = (current_step_joins[start].find(at) == -1 and line_points[start+increment]!=at)
	return valid

	

func split(point, index_of_point_before_slit):
#	print("splitting:", point)
	emit_signal("split",point)
	line_points.insert(posmod(index_of_point_before_slit,line_points.size()), point)
#	draw_points.append(point)
	pass
	

func clear_caches():
	current_step_joins[0] = []
	current_step_joins[-1] = []

func join_point(index):
	var join_point = line_points[index]
#	print("joining:",join_point)
	emit_signal("join",join_point)
	line_points.remove(posmod(index,line_points.size()))

