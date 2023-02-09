extends Node2D

onready var line: Line2D = $line
onready var raycast: RayCast2D = $raycast

export var forgiveness_radius := 50.0

var draw_triangles := []
var draw_internal_triangles := []

var draw_points := PoolVector2Array()
var draw_join_points := PoolVector2Array()
var line_points := PoolVector2Array([Vector2(),Vector2()])

var draw_collided_points := PoolVector2Array()

var raycast_previous_cast_to := Vector2()

var raycast_previous_origin := Vector2()

var current_step_joins = PoolVector2Array()

func clear_render_objects():
	draw_triangles = []
	draw_internal_triangles = []
	draw_points = PoolVector2Array()
	draw_join_points = PoolVector2Array()
	draw_collided_points = PoolVector2Array()

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("A") or Input.is_key_pressed(KEY_SPACE):
		var to = get_global_mouse_position()
		step(to)
	update()
	

func step(to:Vector2) -> void:
	current_step_joins = PoolVector2Array()
	clear_render_objects()
	check_new_logic(to)
	
func check_splits(
		raycast_origin: Vector2, 
		previous_raycast_end: Vector2, 
		current_raycast_end: Vector2
	):
	draw_triangles.append(PoolVector2Array([raycast_origin,previous_raycast_end,current_raycast_end]))
	var collided_points = get_collided_points(raycast_origin, previous_raycast_end, current_raycast_end)
	if !collided_points.empty():
		if collided_points.size() == 1:
			split_at(collided_points[0])
			return true
		
		var OA = previous_raycast_end-raycast_origin
		var OB = current_raycast_end-raycast_origin
		var OAxOB = OA.cross(OB)
		
		var direction_of_spin = sign(OAxOB)
		
		var closest_point = collided_points[0]
		var closest_pseudo_angle = -1000
		
		
		for point in collided_points:

			var OP = point-raycast_origin
			
			"""
			− ||a|| ||b|| ≤ a · b ≤ ||a|| ||b|| ⇒ |a · b| ≤ ||a|| ||b||
			which means
			− 1 ≤ (a · b)/||a|| ||b|| ≤ 1
			"""
#			var pseudo_angle = (pseudoangle(OP)-pseudoangle(OA))*direction_of_spin
			var pseudo_angle = pseudoangle(OP,OA)
#			print(pseudo_angle)
			if pseudo_angle > closest_pseudo_angle:
				closest_point = point
				closest_pseudo_angle = pseudo_angle
			
		split_at(closest_point)
		return true
	return false

func check_join(
		previous_raycast_end: Vector2, 
		current_raycast_end: Vector2
	) -> bool:
	var raycast_origin = line_points[-2]
	
	if raycast_origin == raycast_previous_origin:
		join_last_two()
		return true
	
	
	if is_swing_from_side_to_side(
		raycast_previous_origin, 
		raycast_origin, 
		previous_raycast_end, 
		current_raycast_end
	):
		join_last_two()
		return true
	
	return false
	

#previous_non_zero_side_of_swing accounts for swings that start at exactly 0 degrees from the segment
#we need to remember what was the previous swing so that we can conclude 
#whether we are moving from A to 0 to B or from A to 0 to A back again
var previous_non_zero_side_of_swing := 0.0
static func is_swing_from_side_to_side(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)
#	print("sign_B: ", sign_B)
#	if sign_B == 0:
#		return false
#	if sign_A == 0:
#		sign_A = previous_non_zero_side_of_swing
#	print("sign_A: ", sign_A)
#
	
	return sign_A != sign_B

static func get_side_of_swing(Q:Vector2,O:Vector2,A:Vector2):
	var QO = O - Q
	var OA = A - O
	var QOxOA = QO.cross(OA)
	
	return sign(QOxOA)

static func is_swing_from_side_to_middle(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)

	
	return sign_A != 0 and sign_B == 0
static func is_swing_from_middle_to_side(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)

	
	return sign_A == 0 and sign_B != 0
static func get_side_of_full_swing(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)

	if sign_A == sign_B:
		return sign_A
	if sign_B == 0:
		return -sign_A
	return sign_B
	
static func get_current_side_of_swing(Q:Vector2, O:Vector2, P:Vector2):
	return sign((O-Q).cross(P-O))

func split_at(point:Vector2):
	print("splitting:", point)
	
#	previous_non_zero_side_of_swing = get_current_side_of_swing(line_points[-2], point, line_points[-1])
	var global_end = raycast.cast_to+raycast.global_position
	raycast_previous_origin = raycast.global_position
	raycast.global_position = point#+raycast.global_position.direction_to(point)
	raycast.cast_to = global_end-raycast.global_position
	line_points[-1] = point
	line_points.append(global_end)
	draw_points.append(point)
	pass

func split_at_new(point:Vector2):
	print("splitting:", point)
	line_points.insert(line_points.size()-1,point)
	draw_points.append(point)
	pass


func join_last_two():
	print("joining")
	draw_join_points.append(line_points[-2])
	line_points.remove(line_points.size()-2)
	var global_end = raycast.cast_to+raycast.global_position
	raycast_previous_origin = line_points[-3] if line_points.size()>2 else Vector2()
	var new_origin = line_points[-2] if line_points.size()>1 else Vector2()
	raycast.global_position = new_origin#+raycast.global_position.direction_to(new_origin)
	line_points[-1] = global_end
	raycast.cast_to = global_end-raycast.global_position


func join_last_two_new():
	print("joining")
	current_step_joins.append(line_points[-2])
	draw_join_points.append(line_points[-2])
	line_points.remove(line_points.size()-2)
	
	

func get_collided_points(
		raycast_origin: Vector2,
		previous_raycast_end: Vector2,
		current_raycast_end: Vector2
	) -> PoolVector2Array:
	
	if !triangle_has_area(raycast_origin,previous_raycast_end,current_raycast_end):
		return PoolVector2Array()
	var query_shape := ConvexPolygonShape2D.new()
	query_shape.points = PoolVector2Array([raycast_origin,previous_raycast_end,current_raycast_end])
	var query = Physics2DShapeQueryParameters.new()
	query.collision_layer = 1
	query.shape_rid = query_shape.get_rid()
	var space = get_world_2d().direct_space_state
	var result = space.intersect_shape(query)
	var collided_points = PoolVector2Array()

	var square_epsilon = 1.0
	
	for entry in result:
		var global_polygon_points = get_collider_global_points(entry)
		
		if Input.is_action_pressed("C"):
			print("checking(",
				raycast_origin,", ",
				previous_raycast_end,", ",
				current_raycast_end,")")
				
		
		for point in global_polygon_points:
			var square_dist = point.distance_squared_to(raycast_origin)
			var is_too_close_to_last_splitting_point = square_dist<square_epsilon
			
			if is_too_close_to_last_splitting_point:
				continue
#
			var is_inside = point_is_inside_triangle_inclusive(point,
				raycast_origin,
				previous_raycast_end,
				current_raycast_end)
				
#			var is_inside = Geometry.point_is_inside_triangle(point,
#					raycast_origin,
#					previous_raycast_end,
#					current_raycast_end
#				)
				
			if Input.is_action_pressed("C"):
				print("point ",point," matches:", is_inside)
				
			if !is_inside:
				continue
			
			collided_points.append(point)
	return collided_points
#	update()

func _draw() -> void:
	
	for draw_triangle in draw_internal_triangles:
		draw_triangle.append(draw_triangle[0])
		if !Geometry.triangulate_polygon(draw_triangle).empty():
			draw_colored_polygon(draw_triangle,Color.yellow*0.1)
		draw_polyline(draw_triangle,Color.yellow*0.75)

	var i := 0
	for draw_triangle in draw_triangles:
		if !Geometry.triangulate_polygon(draw_triangle).empty():
			draw_colored_polygon(draw_triangle,Color.green.linear_interpolate(Color.cyan,i*0.5)*0.25)
		draw_triangle.append(draw_triangle[0])
		draw_polyline(draw_triangle,Color.red*0.75)
		i+=1
	
	var zoom = $mouse_zoomable_camera.zoom
	var rect_size = Vector2(10,10)*zoom
	var rect_offset = -rect_size*0.5
	for point in draw_points:
		draw_rect(Rect2(point+rect_offset,rect_size),Color(1.0,0.0,0.0,0.5))
		pass
	for point in draw_join_points:
		pass
		draw_rect(Rect2(point+rect_offset,rect_size),Color(0.0,0.0,1.0,0.5))
		
	draw_polyline(line_points,Color.green)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("B"):
		print(line_points)
	if event.is_action_pressed("ui_left",true):
		step(line_points[-1]+Vector2.LEFT)
	if event.is_action_pressed("ui_right",true):
		step(line_points[-1]+Vector2.RIGHT)
	if event.is_action_pressed("ui_up",true):
		step(line_points[-1]+Vector2.UP)
	if event.is_action_pressed("ui_down",true):
		step(line_points[-1]+Vector2.DOWN)

static func pseudoangle(vec:Vector2, vec_base: Vector2 = Vector2.RIGHT):
	return vec_base.dot(vec)/sqrt(vec_base.length_squared()*vec.length_squared())
#	return 1.0 - vec.x/(abs(vec.x)+abs(vec.y))*sign(vec.y) if vec else 0.0




static func point_is_inside_triangle_inclusive(p:Vector2,a:Vector2,b:Vector2,c:Vector2):
	var result = (
		(p == a or p == b or p == c) or
		(triangle_has_area(a,b,c) and Geometry.point_is_inside_triangle(p,a,b,c)) or
		Geometry.get_closest_point_to_segment_2d(p,a,b) == p or
		Geometry.get_closest_point_to_segment_2d(p,b,c) == p or
		Geometry.get_closest_point_to_segment_2d(p,c,a) == p
	)
	
	if result:
		print ("p == a or p == b or p == c :", p == a or p == b or p == c)
		print("triangle_has_area(a,b,c) : ", triangle_has_area(a,b,c))
		print("Geometry.point_is_inside_triangle(p,a,b,c) : ",Geometry.point_is_inside_triangle(p,a,b,c))
		print("Geometry.get_closest_point_to_segment_2d(p,a,b) == p : ", Geometry.get_closest_point_to_segment_2d(p,a,b) == p)
		print("Geometry.get_closest_point_to_segment_2d(p,b,c) == p : ", Geometry.get_closest_point_to_segment_2d(p,b,c) == p)
		print("Geometry.get_closest_point_to_segment_2d(p,c,a) == p : ", Geometry.get_closest_point_to_segment_2d(p,c,a) == p)

	return result

static func point_is_inside_triangle_inclusive_but_exclude_first_segment(p:Vector2,a:Vector2,b:Vector2,c:Vector2):
	var result = (
		(p == c) or
		(triangle_has_area(a,b,c) and Geometry.point_is_inside_triangle(p,a,b,c)) or
		Geometry.get_closest_point_to_segment_2d(p,b,c) == p or
		Geometry.get_closest_point_to_segment_2d(p,c,a) == p
	)
	
	if result:
		print ("p == c :", p == c)
		print("triangle_has_area(a,b,c) : ", triangle_has_area(a,b,c))
		print("Geometry.point_is_inside_triangle(p,a,b,c) : ",Geometry.point_is_inside_triangle(p,a,b,c))
		print("Geometry.get_closest_point_to_segment_2d(p,b,c) == p : ", Geometry.get_closest_point_to_segment_2d(p,b,c) == p)
		print("Geometry.get_closest_point_to_segment_2d(p,c,a) == p : ", Geometry.get_closest_point_to_segment_2d(p,c,a) == p)

	return result

func _ready() -> void:
	raycast.global_position = line_points[-2]
	raycast.cast_to = raycast.to_local(line_points[-1])
	raycast_previous_cast_to = raycast.cast_to
	raycast_previous_origin = line_points[-3] if line_points.size()>=3 else line_points[-2]

static func triangle_has_area(a:Vector2,b:Vector2,c:Vector2)->bool:
#	print("Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c) :", Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c))
#	print("a : ", a)
#	return Geometry.triangulate_polygon(PoolVector2Array([a,b,c]))
#	return true
#	print("closest_point_uncapped:",Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c))
#	print("a:",a)
	
	return Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c) != a



var latest_non_zero_side_of_swing := 0.0
func check_new_logic(to:Vector2) -> bool:
	var O = line_points[-2]
	var A = line_points[-1] #rope pre swing position
	line_points[-1] = to
	var B = line_points[-1] #rope post swing position
	#       .O
	#	   / \
	#	  /   \
	#	 /     \
	#	/       \
	#  .A        .B
	
	while true:
		
		if A==B:
			return false
		O = line_points[-2] #rope latest split position (or rope origin if no splits)
		if line_points.size()>=3:
			#rope previous split position
			var Q := line_points[-3]
			
			#intersection between QO's line and AB
			#U is null if no intersection or same line
			var U = Geometry.line_intersects_line_2d(Q,O-Q,A,B-A)
			var parallel_swing = U == null
			var A_is_right_at_the_middle = Geometry.line_intersects_line_2d(O,A-O,Q,O-Q) == null
			var current_side_of_swing = get_side_of_swing(Q,O,A)
			if current_side_of_swing:
				latest_non_zero_side_of_swing = current_side_of_swing
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
			elif is_swing_from_side_to_middle(Q,O,A,B):
				#       .Q
				#       |
				#       |
				#       .O
				#	   /|
				#	  / |
				#	 /  |
				#	/   |
				#  .A   .B
				
				
				if check_splits_new(A,B):
					Q = line_points[-3]
					O = line_points[-2]
					latest_non_zero_side_of_swing = get_side_of_full_swing(Q,O,A,B)
				
				return true
			elif is_swing_from_middle_to_side(Q,O,A,B):
				#       .Q
				#       |
				#       |
				#       .O
				#	    |\
				#	    | \
				#	    |  \
				#	    |   \
				#       .A   .B
				if latest_non_zero_side_of_swing != get_side_of_swing(Q,O,B):
					join_last_two_new()
					continue
				
				return true
			elif is_swing_from_side_to_side(Q,O,A,B):
				#       .Q
				#       |
				#       |
				#       .O
				#	   /.\
				#	  / . \
				#	 /  .  \
				#	/   .   \
				#  .A   .U   .B
				if !check_splits_new(A,U):
					join_last_two_new()
					A = U
					continue
				check_splits_new(U,B)
				return true
			else:
				#.Q_____.O..............(U isn't inside AB)
				#	   / \
				#	  /   \
				#	 /     \
				#	/       \
				#  .A        .B
				check_splits_new(A,B)
				return true
		else:
			#       .O
			#	   / \
			#	  /   \
			#	 /     \
			#	/       \
			#  .A        .B
			if check_splits_new(A,B):
				var Q = line_points[-3]
				O = line_points[-2]
				latest_non_zero_side_of_swing = get_side_of_full_swing(Q,O,A,B)
			return true
			
		
	return true

static func get_collider_global_points(entry):
	var collider = entry.collider # The colliding object.
	var collider_id = entry.collider_id # The colliding object's ID.
	var rid = entry.rid # The intersecting object's RID.
	var shape = entry.shape # The shape index of the colliding shape.
	var shape_rid = Physics2DServer.body_get_shape(collider.get_rid(),shape)
	var shape_data = Physics2DServer.shape_get_data(shape_rid)
	var t : Transform2D = collider.global_transform*(Physics2DServer.body_get_shape_transform(collider.get_rid(),shape))
	var xformed_shape_data = t.xform(shape_data)
	return xformed_shape_data


func check_splits_new(A:Vector2,B:Vector2):
	var O :Vector2 = line_points[-2]
	draw_triangles.append(PoolVector2Array([O,A,B]))
	
	var points_in_triangle = get_all_collider_points_inside_triangle(O,A,B)
	if points_in_triangle.empty():
		return false
	
	if points_in_triangle.size()==1:
		var point = points_in_triangle[0]
		var valid = check_single_split(point)
		if valid:
			split_at_new(point)
		return valid
		
	var comparator = PointComparatorByAngleWithSegment.new(O,A)
	points_in_triangle.sort_custom(comparator, "compare_points_asc")
	var current_square_dist = 0
	var at_least_one_split = false
	for p in points_in_triangle:
		draw_collided_points.append(p)
		var point :Vector2 = p
		draw_internal_triangles.append(PoolVector2Array([A,B,line_points[-2]]))
		if (
			point_is_inside_triangle_inclusive_but_exclude_first_segment(p,line_points[-2],A,B)
			and check_single_split(point)
		):
			split_at_new(point)
			at_least_one_split = true
	
	return at_least_one_split
		
		
	
func check_single_split(at):
	var valid = (current_step_joins.find(at) == -1 and line_points[-2]!=at)
	return valid

func get_all_collider_points_inside_triangle(O:Vector2,A:Vector2,B:Vector2)->Array:
	if !triangle_has_area(O,A,B):
		return []
	var points_inside_triangle = []
	
	var result = query_triangle(O,A,B)
	var square_epsilon = 0.5
	for entry in result:
		var global_polygon_points = get_collider_global_points(entry)
		
		for point in global_polygon_points:
			var square_dist = point.distance_squared_to(O)
			if (
				square_dist<square_epsilon or 
				!point_is_inside_triangle_inclusive_but_exclude_first_segment(point,O,A,B)
			):
				continue
			
			points_inside_triangle.append(point)
	
	return points_inside_triangle


func query_triangle(O,A,B):
	var query_shape := ConvexPolygonShape2D.new()
	query_shape.points = PoolVector2Array([O,A,B])
	var query = Physics2DShapeQueryParameters.new()
	query.collision_layer = 1
	query.shape_rid = query_shape.get_rid()
	var space = get_world_2d().direct_space_state
	return space.intersect_shape(query)

